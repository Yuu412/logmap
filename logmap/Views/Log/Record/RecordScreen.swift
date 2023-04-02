//
//  RecordScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/01.
//

import SwiftUI

struct RecordScreen: View{
    @State var progressValue: CGFloat = INFINITESIMAL
    
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View{
        VStack {
            GraphSection(
                progressValue: self.$progressValue,
                dateFormatter: self.dateFormatter
            )
            
            TimeChangeSection(progressValue: self.$progressValue)
                .padding(.vertical, FrameSize().height * 0.05)
            
            // 計測画面への遷移
            NavigationLink {
                StopWatchView()
            } label: {
                Text("START")
                    .primaryTextButtonModifier()
            }
        }
        .padding(.bottom, FrameSize().height*0.05)
        .navigationBarTitleDisplayMode(.inline)
        .reverseNavigationBar(title: "目標時間の設定")
        
    }
}

// 時間加減部
struct TimeChangeSection: View{
    @Binding var progressValue: CGFloat
    
    func min2str(minutes: Double) -> String {
        var retValue: String
        var roundedMinutes: Int
        
        roundedMinutes = Int((100 * minutes).rounded())
        
        if(roundedMinutes == 0){
            retValue = "00.00"
        } else {
            retValue = String(roundedMinutes) + ".00"
        }
        
        return retValue
    }
    
    var body: some View{
        HStack {
            Spacer()
            
            // 目標時間の減算ボタン
            Button(action: {
                self.progressValue -= 0.1
            }, label: {
                Image(systemName: "minus")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
            })
            .primaryIconButtonModifier()
            
            Spacer()
            
            Text(min2str(minutes: progressValue))
                .timerTextModifier(color: Color.Gray)
            
            Spacer()
            
            // 目標時間の減算ボタン
            Button(action: {
                self.progressValue += 0.1
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
            })
            .primaryIconButtonModifier()
            
            Spacer()
        }
        
    }
}

// 時間表示のための円形プログレスバー表示部
struct GraphSection: View{
    @Binding var progressValue: CGFloat
    var dateFormatter: DateFormatter
    
    var body: some View{
        ZStack {
            BackGroundShape()
                .fill(Color.Blue)
            
            TimeCircleGraph(
                progressValue: self.$progressValue,
                dateFormatter: self.dateFormatter
            )
            .frame(width: FrameSize().width * 0.75)
        }
        
    }
}

// プログレスバーのビュー
struct TimeCircleGraph: View {
    @Binding var progressValue: CGFloat
    var dateFormatter: DateFormatter
    
    @State var nowDate = Date()
    @State var dateText = ""
    
    var body: some View {
        ZStack {
            // 背景の点線の円
            Circle()
                .stroke(style: StrokeStyle(dash: [2, 4]))
                .opacity(0.5)
                .foregroundColor(Color.white)
            
            /*
             // 円周の1/4刻みのメモリ
             Circle()
             .stroke(style: StrokeStyle(lineWidth: 12.5, dash: [2, FrameSize().width * 0.68 * Double.pi * 1/4]))
             .opacity(0.8)
             .foregroundColor(Color.white)
             .frame(width: FrameSize().width * 0.68)
             */
            
            // プログレスバーを示す円
            Circle()
            // 始点, 終点を指定して円を描画（0.0-1.0の範囲に正規化した値を指定）
                .trim(from: 0.0, to: min(progressValue, 1.0))
            // 線の端の形状・色を指定
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.white)
            // 原点を時計の12時の位置に回転させる
                .rotationEffect(Angle(degrees: 270))
            // 加減時のアニメーションを設定
                .animation(.easeInOut(duration: 1.0), value: progressValue)
            
            // プログレスバーの先端の円の背景
            Circle()
                .trim(from: min(progressValue, 1.0) - INFINITESIMAL , to: min(progressValue, 1.0))
                .stroke(style: StrokeStyle(
                    lineWidth: 45.0,
                    lineCap: .round,
                    lineJoin: .round)
                )
                .foregroundColor(Color.white)
                .opacity(0.25)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: progressValue)
            
            // プログレスバーの先端の円
            Circle()
                .trim(from: min(progressValue, 1.0) - INFINITESIMAL , to: min(progressValue, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.white)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: progressValue)
            
            VStack{
                Image("青チャート")
                    .resizable()
                    .scaledToFit()
                    .frame(width: FrameSize().width * 0.3)
                    .padding(.top, 15)
                
                // 目標時間が経過した際の時刻
                Label(dateText.isEmpty ? "\(dateFormatter.string(from: nowDate))" : dateText, systemImage: "flag")
                    .onChange(of: progressValue){ newValue in
                        self.nowDate = Date()
                        //現在時刻に目標時間を加算した時刻を計算
                        self.nowDate = nowDate + (60 * 100 * newValue)
                        dateText = "\(dateFormatter.string(from: nowDate))"
                    }
                    .padding(.top, 5)
                    .foregroundColor(Color.white)
            }
        }
    }
}

// 背景に表示する円形のオブジェクト
struct BackGroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 2.5*width, y: -0.5*height))
        path.addCurve(
            to: CGPoint(x: 0.5*width, y: height),
            control1: CGPoint(x: 2.5*width, y: 0.3*height),
            control2: CGPoint(x: 1.5*width, y: height)
        )
        path.addCurve(
            to: CGPoint(x: -1.5*width, y: -0.5*height),
            control1: CGPoint(x: -0.65*width, y: height),
            control2: CGPoint(x: -1.5*width, y: 0.3*height)
        )
        path.closeSubpath()
        
        return path
    }
}

struct RecordScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecordScreen()
    }
}
