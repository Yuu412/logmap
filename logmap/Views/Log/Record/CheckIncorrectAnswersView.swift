//
//  CheckIncorrectAnswersView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/09.
//

import SwiftUI

struct CheckIncorrectAnswersView: View {
    var capturedImage: UIImage
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.BackgroundGray.edgesIgnoringSafeArea(.all)
                VStack {
                    // sheetのNavigation部分
                    SheetTitleSection()
                    
                    // 撮影した写真の描画と、枠の描画 部分
                    TakenPhotoSection(capturedImage: self.capturedImage)
                    
                    // 不正解の理由の選択部分
                    SelectIncorrectReasonSection()
                    
                    Spacer()
                    
                    // sheetの各画面への遷移部分
                    SheetTransitionSection()
                }
                .frame(width: FrameSize().width)
                .padding(.horizontal)
            }
        }
    }
}


struct SheetTitleSection: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.Blue)
                    Text("再撮影")
                        .foregroundColor(Color.Blue)
                })
                .padding(.leading)
                
                Spacer()
            }
            
            Text("問題部分を選択")
                .font(.system(size: 18))
                .fontWeight(.bold)
        }
        .padding(.vertical)
    }
}

struct TakenPhotoSection: View {
    var capturedImage: UIImage
    
    @State var startPoint: CGPoint?
    @State var endPoint: CGPoint?
    
    var body: some View {
        GeometryReader { geo in
            let imageSize = CGSize(
                width: geo.size.width,
                height: FrameSize().height * 0.6
            )
            
            ZStack{
                Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: imageSize.width,
                        height: imageSize.height,
                        alignment: .top
                    )
                    .clipped()
                
                // 不正解箇所を示す四角形
                if let startPoint = self.startPoint, let endPoint = self.endPoint {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: 3)
                        .frame(
                            width: abs((endPoint.x) - (startPoint.x)),
                            height: abs((endPoint.y) - (startPoint.y))
                        )
                        .offset(
                            x: startPoint.x - (imageSize.width / 2) + (endPoint.x - startPoint.x) / 2,
                            y: startPoint.y - (imageSize.height / 2) + (endPoint.y - startPoint.y) / 2
                        )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        startPoint = value.startLocation
                        endPoint = value.location
                        
                        print(startPoint!)
                        print(endPoint!)
                    }
                    .onEnded { value in
                        endPoint = value.location
                    }
            )
        }
    }
}


// 不正解理由のテストデータの構造体
struct IncorrectReason: Identifiable {
    var id = UUID()
    var name: String
    var color: Color
    var imageName: String
}

struct SelectIncorrectReasonSection: View {
    // 選択された不正解理由のIDを保持する変数
    @State private var selectedID: UUID?
    
    // 不正解理由のテストデータ
    var incorrectReasons: [IncorrectReason] = [
        .init(name: "計算ミス", color: Color.Green, imageName: "incorrectReason"),
        .init(name: "理解不足", color: Color.Orange, imageName: "incorrectReason"),
        .init(name: "勘違い", color: Color.Purple, imageName: "incorrectReason"),
        .init(name: "テキスト", color: Color.Pink, imageName: "incorrectReason"),
        .init(name: "テキスト", color: Color.PaleBlue, imageName: "incorrectReason"),
        .init(name: "原因不明", color: Color.Yellow, imageName: "incorrectReason"),
        
    ]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(incorrectReasons) { incorrectReason in
                    VStack {
                        VStack{
                            Image(incorrectReason.imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 10)
                                .background(Color.white)
                        }
                        HStack(){
                            Spacer()
                            Text(incorrectReason.name)
                                .foregroundColor(Color.white)
                                .baseTextModifier()
                                .padding(.vertical, 5)
                            Spacer()
                        }
                    }
                    .background(incorrectReason.color)
                    .frame(width: 100)
                    .baseCardModifier()
                    .overlay(
                        // 選択されたカードに赤色の枠を表示する
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.Blue, lineWidth: selectedID == incorrectReason.id ? 3 : 0)
                    )
                    .onTapGesture {
                        // カードがタップされたら、選択されたカードのIDを更新する
                        selectedID = incorrectReason.id
                    }
                    
                }
            }
            .padding(.vertical)
        }
    }
}

struct SheetTransitionSection: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isCustomCameraViewPresented = false
    
    var body: some View {
        HStack{
            Button(action: {
                isCustomCameraViewPresented.toggle()
            }, label: {
                Text("スキップ")
                    .fontWeight(.medium)
                    .foregroundColor(Color.Gray)
            })
            .sheet(isPresented: $isCustomCameraViewPresented, content: {
                EnterLogDetailsView()
            })
            .padding(.leading)
            
            Spacer()
            
            NavigationLink(destination: EnterLogDetailsView()) {
                Text("次へ")
                    .fontWeight(.medium)
                    .foregroundColor(Color.Blue)
            }
            .padding(.trailing)
            
        }
        
    }
}
