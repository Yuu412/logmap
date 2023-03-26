//
//  ReportScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

// プログレスバーのビュー
struct CircularProgressBar: View {
    @Binding var progressValue: CGFloat
    @State var isAnimation = false
    
    @State var transitionValue = 0.0
    
    var body: some View {
        ZStack {
            // 背景の円
            Circle()
                .stroke(lineWidth: 16.0)
                .opacity(0.15)
                .foregroundColor(Color.Blue)
            
            // 進捗を示す円
            Circle()
            // 始点/終点を指定して円を描画する
            // 始点/終点には0.0-1.0の範囲に正規化した値を指定する
                .trim(from: 0.0, to: min(transitionValue, 1.0))
            // 線の端の形状などを指定
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.Blue)
            // デフォルトの原点は時計の12時の位置ではないので回転させる
                .rotationEffect(Angle(degrees: 270))
                .onAppear(){
                    withAnimation(.easeInOut(duration: 1.0)) {
                        transitionValue = self.progressValue
                    }
                }
                .onDisappear(){
                    transitionValue = 0.0
                }
            
            // 進捗率のテキスト
            Text(String(format: "%.0f%%", min(progressValue, 1.0) * 100.0))
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.Blue)
        }
    }
}

struct ReportScreen: View{
    @State var progressValue: CGFloat = 0.3
    
    var body: some View{
        ScrollView {
            VStack {
                Text("レポート")
                
                CircularProgressBar(progressValue: $progressValue)
                    .frame(width: 150.0, height: 150.0)
                    .padding(32.0)
                    
                Spacer()
            }
        }
        .padding(.top, 10)
    }
}

struct ReportScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportScreen()
    }
}

