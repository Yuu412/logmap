//
//  ProgressCircle.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/01.
//


import SwiftUI

// 勉強量の1日目標の円グラフ
struct AmountStudyProgressCircular: View {
    // 引数
    @Binding var progressValue: CGFloat
    var unit: String    // 単位（問, h etc.）
    
    @State var isAnimation = false
    @State var transitionValue = 0.0
    
    let themeColor: Color = Color.Blue
    
    var body: some View {
        ZStack {
            // 背景の円
            Circle()
                .stroke(lineWidth: 14.0)
                .opacity(0.15)
                .foregroundColor(themeColor)
            
            // 進捗を示す円
            Circle()
            // 始点/終点を指定して円を描画する
            // 始点/終点には0.0-1.0の範囲に正規化した値を指定する
                .trim(from: 0.0, to: min(transitionValue, 1.0))
            // 線の端の形状などを指定
                .stroke(style: StrokeStyle(lineWidth: 18.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(themeColor)
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
            HStack (alignment: .bottom){
                Text(String(format: "%.0f%", min(progressValue, 1.0) * 100.0))
                    .font(.custom("HiraginoSans-W3", size: 32))
                Text(self.unit)
                    .font(.callout)
            }
            .foregroundColor(themeColor)
            .fontWeight(.medium)
        }
        .frame(width: FrameSize().width * 0.3)
        .padding(20)
        .padding(.bottom, 0)
    }
}

// 横スクロールで選択する日付の円
struct DateProgressCircular: View {
    // 引数
    @State var progressValue: CGFloat
    var contentText: String
    var reverseColor: Bool
    
    @State var isAnimation = false
    @State var transitionValue = 0.0
    
    let themeColor: Color = Color.Blue
    
    var body: some View {
        ZStack {
            
            // 背景の円
            Circle()
                .foregroundColor(reverseColor ? Color.Blue : Color.white)
            
            // 背景の円
            Circle()
                .stroke(lineWidth: 3.0)
                .opacity(0.15)
                .foregroundColor(themeColor)
            
            // 進捗を示す円
            Circle()
                .trim(from: 0.0, to: min(transitionValue, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(themeColor)
                .rotationEffect(Angle(degrees: 270))
                .onAppear(){
                    withAnimation(.easeInOut(duration: 1.0)) {
                        transitionValue = self.progressValue
                    }
                }
                .onDisappear(){
                    transitionValue = 0.0
                }
            
            Text(self.contentText)
                .foregroundColor(reverseColor ? Color.white : Color.Gray)
                .fontWeight(.medium)
        }
        .frame(width: 38, height: 38)
        
    }
}

// グラフの要素の構造体
struct TimeAllocationGraphElement: Hashable {
    var subject: PerTimeAllocation
    var startPoint: Double
}

// 勉強時間の配分の円グラフ
struct TimeAllocationCircular: View {
    var subjects: [PerTimeAllocation]  // 教科毎のPerTimeAllocationの可変長引数を受け取る
    
    // subjectsの合計時間
    var totalTime: Double
    var graphElements: [TimeAllocationGraphElement] = []
    var totalRate: Double = 0.0
    
    init(subjects: [PerTimeAllocation]){
        // subjectsを時間(hour)でソートする
        self.subjects = subjects
        self.subjects.sort(by: { $0.hour > $1.hour })
        
        // subjectsのhourの要素を合計して、totalTimeに代入する
        self.totalTime = self.subjects.reduce(0) { $0 + $1.hour }
        
        // グラフ要素の生成
        for i in 0..<self.subjects.count {
            // TimeAllocationGraphElementを生成し、graphElementsに追加する
            self.graphElements.append(
                TimeAllocationGraphElement(
                    subject: self.subjects[i],
                    startPoint: totalRate
                )
            )
            
            // totalTimeに対する各科目の時間の比率を算出し、totalRateに加算する
            self.totalRate += self.subjects[i].hour / self.totalTime
        }
    }
    
    
    var body: some View {
        ZStack {
            ForEach(graphElements, id: \.self) { graphElement in
                Circle()
                    .trim(
                        from: graphElement.startPoint,
                        to: graphElement.startPoint + graphElement.subject.hour / totalTime - 0.005
                    )
                    .stroke(style: StrokeStyle(lineWidth: 18.0))
                    .foregroundColor(graphElement.subject.color)
                    .rotationEffect(Angle(degrees: 270))
            }
            
            // 進捗率のテキスト
            VStack{
                Text("合計時間")
                    .smallTextModifier()
                    .foregroundColor(Color.gray)
                
                HStack (alignment: .bottom){
                    Spacer()
                    
                    Text(String(self.totalTime))
                        .font(.custom("HiraginoSans-W3", size: 32))
                        .kerning(-2.0)
                    
                    Text("h")
                        .font(.callout)
                    
                    Spacer()
                }
                .foregroundColor(Color.Blue)
                .fontWeight(.medium)
                
            }
        }
        .frame(width: FrameSize().width * 0.4)
        .padding(20)
        .padding(.bottom, 0)
    }
}
