//
//  InputCompletedView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/15.
//

import SwiftUI

struct InputCompletedView: View {
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    var body: some View {
        VStack{
            Text("お疲れ様でした！")
                .foregroundColor(Color.Blue)
                .pageTitleModifier()
                .padding(.vertical, 20)
            
            AmountGoalSection()
                .padding(.vertical, 10)
            
            TimeGoalSection()
                .padding(.vertical, 10)
            
            Spacer()
            
            Button(action: {
                navigationVM.popToRoot()
            }, label: {
                Text("閉じる    ")
                    .primaryTextButtonWithIconModifier(
                        iconName: "square.and.pencil",
                        leftIcon: true
                    )
            })
            
            NavigationLink(destination: EnterLogDetailsView()) {
                Text("レポートを確認")
                    .foregroundColor(Color.Blue)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .padding()
            
        }
        .navigationBar(title: "ログの詳細情報", leading: true, trailing: true)
        .padding()
    }
}

// 勉強量の目標達成までの表示カード部分
struct AmountGoalSection: View {
    @State var progressValue: CGFloat = 0.3
    
    var body: some View {
        VStack{
            Text("勉強量の目標達成まで")
                .sectionTitleWithMarkModifier()
                .padding(.horizontal)
            
            HStack{
                AmountStudyProgressCircular(
                    progressValue: $progressValue,
                    unit: "問"
                )
                
                Spacer()
                
                VStack (alignment: .trailing, spacing: 10){
                    Text("ゴール達成まであと")
                        .baseTextModifier()

                    HStack (alignment: .bottom){
                        Text("25")
                            .font(.custom("HiraginoSans-W3", size: 60))
                            .fontWeight(.bold)
                        Text("問")
                            .subheadlineTextModifier()
                    }
                    .foregroundColor(Color.Blue)
                    
                    Text("志望校平均 29問")
                        .baseTextModifier()
                }
                .frame(width: FrameSize().width * 0.35)
                .padding(.trailing, 0)
            }

        }
        .frame(width: FrameSize().width * 0.9)
        .padding(.top, 10)
        .padding(.trailing, 10)
        .background(Color.white)
        .baseCardModifier()
    }
}



// 勉強量の目標達成までの表示カード部分
struct TimeGoalSection: View {
    @State var progressValue: CGFloat = 0.3
    
    var body: some View {
        VStack{
            Text("勉強時間の目標時間まで")
                .sectionTitleWithMarkModifier()
                .padding(.horizontal)
            
            HStack{
                TimeStudyProgressCircular(progressValue: $progressValue)
                
                Spacer()
                
                VStack (alignment: .trailing, spacing: 10){
                    Text("ゴール達成まであと")
                        .baseTextModifier()
                    
                    HStack (alignment: .bottom){
                        Text("1.2")
                            .font(.custom("HiraginoSans-W3", size: 60))
                            .fontWeight(.bold)
                        Text("h")
                            .subheadlineTextModifier()
                    }
                    .foregroundColor(Color.Purple)
                    
                    Text("志望校平均 2.2h")
                        .baseTextModifier()
                }
                .frame(width: FrameSize().width * 0.35)
                .padding(.trailing, 0)
            }
        }
        
        .frame(width: FrameSize().width * 0.9)
        .padding(.top, 10)
        .padding(.trailing, 10)
        .background(Color.white)
        .baseCardModifier()
    }
}

// 勉強時間の目標達成までの円グラフ
struct TimeStudyProgressCircular: View {
    @Binding var progressValue: CGFloat
    @State var isAnimation = false
    
    @State var transitionValue = 0.0
    
    let themeColor: Color = Color.Purple
    
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
                    .font(.custom("HiraginoSans-W3", size: 40))
                Text("h")
                    .font(.callout)
            }
            .foregroundColor(themeColor)
            .fontWeight(.medium)
        }
        .frame(width: FrameSize().width * 0.3)
        .padding(25)
    }
}


struct InputCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        InputCompletedView()
    }
}
