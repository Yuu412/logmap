//
//  EnterLogImageView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/09.
//

import SwiftUI

struct EnterLogImageView: View{
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    var body: some View{
        VStack {
            Text("問題内容の撮影")
                .timerHeadlineModifier(color: Color.Blue)
                .padding(.vertical, FrameSize().height * 0.025)
            
            Image("takeLogPicture")
            
            Text("スキップを選択すると、\n約３０種類のログ情報の分析が\n無効になります。")
                .frame(maxWidth: FrameSize().width * 0.7, alignment: .center)
                .multilineTextAlignment(.center)
                .baseTextModifier()
                .padding(.vertical, FrameSize().height * 0.025)
            
            
            Spacer()
            
            // 計測画面への遷移
            NavigationLink(value: NavView.stopWatchView){
                Text("撮影する")
                    .primaryTextButtonWithIconModifier(
                        iconName: "camera.fill",
                        leftIcon: true
                    )
            }
            Button("スキップする"){
                print("skip!!")
            }
            .padding(.vertical, 10)
            
            Spacer()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBar(title: "ログ取得", leading: false, trailing: true)
        //.reverseNavigationBar(title: "目標時間の設定")
        
    }
}

struct EnterLogImageView_Previews: PreviewProvider {
    static var previews: some View {
        EnterLogImageView()
    }
}
