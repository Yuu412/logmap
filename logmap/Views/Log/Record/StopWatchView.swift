//
//  StopWatchView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/02.
//
//
//  RecordScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/01.
//

import SwiftUI

struct StopWatchView: View{
    let minimumUnit: Double = 0.01
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View{
        VStack {
            ElapsedTimeCircleGraph()
                .frame(width: FrameSize().width * 0.9)
            
            ElapsedTimeSection()
                .padding(.top, FrameSize().height * 0.05)
            
            // 計測画面への遷移
            NavigationLink(value: NavView.enterLogImageView) {
                Text("回答終了")
                    .smallPrimaryTextButtonModifier()
            }
        
            ButtonsSection()

        }
        .padding(.vertical, FrameSize().height * 0.05)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBar(title: "学習中", leading: false, trailing: true)
        .background(Color.Black)
    }
}

// 時間加減部
struct ElapsedTimeSection: View{
    @EnvironmentObject var logVM: LogViewModel
    let minimumUnit: Double = 0.01
    
    var body: some View{
        HStack {
            Spacer()
            
            Text(TimeService().rate2sec(value: logVM.progressTime))
                .timerTextModifier(color: Color.Blue)
                .onAppear{
                    logVM.timerStart()
                }
            
            Spacer()
        }
    }
}

// プログレスバーのビュー
struct ElapsedTimeCircleGraph: View {
    @EnvironmentObject var logVM: LogViewModel
    
    @State var nowDate = Date()
    @State var dateText = ""
    
    let dateFormatter = DateFormatter()
    
    init(){
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    
    var body: some View {
        ZStack {
            // 背景の点線の円
            Circle()
                .stroke(style: StrokeStyle(dash: [2, 4]))
                .foregroundColor(Color.Blue)
            
            // プログレスバーを示す円
            Circle()
            // 始点, 終点を指定して円を描画（0.0-1.0の範囲に正規化した値を指定）
                .trim(from: 0.0, to: min(logVM.progressTime * 0.1, 1.0))
            // 線の端の形状・色を指定
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.Blue)
            // 原点を時計の12時の位置に回転させる
                .rotationEffect(Angle(degrees: 270))
            // 加減時のアニメーションを設定
                .animation(.easeInOut(duration: 1.0), value: logVM.progressTime * 0.1)
            
            // プログレスバーの先端の円の背景
            Circle()
                .trim(from: min(logVM.progressTime * 0.1, 1.0) - INFINITESIMAL , to: min(logVM.progressTime * 0.1, 1.0))
                .stroke(style: StrokeStyle(
                    lineWidth: 45.0,
                    lineCap: .round,
                    lineJoin: .round)
                )
                .foregroundColor(Color.Blue)
                .opacity(0.25)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: logVM.progressTime * 0.1)
            
            // プログレスバーの先端の円
            Circle()
                .trim(from: min(logVM.progressTime * 0.1, 1.0) - INFINITESIMAL , to: min(logVM.progressTime * 0.1, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.Blue)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: logVM.progressTime * 0.1)
            
            VStack{
                Image("青チャート")
                    .resizable()
                    .scaledToFit()
                    .frame(width: FrameSize().width * 0.3)
                    .padding(.top, 15)
                
                // 目標時間が経過した際の時刻
                Label(dateText.isEmpty ? "\(dateFormatter.string(from: nowDate + (60 * 100 * logVM.targetTime)))" : dateText, systemImage: "flag")
                    .padding(.top, 5)
                    .foregroundColor(Color.white)
            }
        }
    }
}

// ボタンのビュー
struct ButtonsSection: View{
    @EnvironmentObject var logVM: LogViewModel
    let minimumUnit: Double = 0.01
    
    var body: some View{
        Button(action: {
            if logVM.mode == .start {
                self.logVM.timerPause()
            } else {
                print("2pat")
                self.logVM.timerStart()
            }
        }, label: {
            if logVM.mode == .start {
                Image(systemName: "pause.circle")
                    .foregroundColor(.Blue)
                    .font(.system(size: 65))
            } else {
                Image(systemName: "play.circle")
                    .foregroundColor(.Blue)
                    .font(.system(size: 65))
            }
        })
        .padding(.vertical, FrameSize().height * 0.025)
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView()
    }
}
