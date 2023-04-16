//
//  EnterLogDetailsView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/15.
//

import SwiftUI

private let horizontalPadding: CGFloat = 25

struct EnterLogDetailsView: View {
    var body: some View {
        VStack{
            PageNumberInputSection()
                .padding(.vertical, 10)
            
            ReviewNumberInputSection()
                .padding(.vertical, 10)
            
            ImplementationDateInputSection()
            
            AnswerTimeInputSection()
                .padding(.vertical, 10)
            
            
            Spacer()
            
            NavigationLink(destination: InputCompletedView()) {
                Text("入力完了")
                    .primaryTextButtonWithIconModifier(
                        iconName: "square.and.pencil",
                        leftIcon: true
                    )
            }
            
            NavigationLink(destination: InputCompletedView()) {
                Text("スキップする")
                    .foregroundColor(Color.Blue)
                    .font(.callout)
            }
        }
        .navigationBar(title: "ログの詳細情報", leading: true, trailing: true)
        .padding(.horizontal, horizontalPadding)
    }
}

// 参考書のページ数の選択部分
struct PageNumberInputSection: View {
    @State var startPoint: Int = 0
    @State var endPoint: Int = 100
    
    @State var widthL: CGFloat = 0
    @State var widthH: CGFloat = FrameSize().width - 125
    
    var body: some View {
        
        VStack{
            Text("参考書のページ数")
                .sectionTitleWithMarkModifier()
            
            VStack{
                PageNumberSlider(
                    startPoint: $startPoint,
                    endPoint: $endPoint,
                    widthL: $widthL,
                    widthH: $widthH
                )
            }
            .padding(.vertical, 10)
        }
        
    }
}

// 参考書のページ数のスライダー部分
struct PageNumberSlider: View {
    @Binding var startPoint: Int
    @Binding var endPoint: Int
    
    @Binding var widthL: CGFloat
    @Binding var widthH: CGFloat
    
    let barMaxWidth = FrameSize().width - horizontalPadding * 5
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.Gray.opacity(0.2))
                .frame(height: 3)
                .cornerRadius(99)
            
            Rectangle()
                .fill(Color.Blue)
                .frame(width: self.widthH - self.widthL, height: 6)
                .offset(x: self.widthL + 40)
            
            HStack(spacing: 0) {
                
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40)
                        .offset(x: self.widthL)
                    
                    Circle()
                        .fill(Color.Blue)
                        .frame(width: 35)
                        .offset(x: self.widthL)
                        .gesture(
                            DragGesture()
                                .onChanged({(value) in
                                    print(self.widthL)
                                    if value.location.x >= 0 && value.location.x <= self.widthH {
                                        self.widthL = value.location.x
                                        self.startPoint = self.getValue(val: self.widthL / self.barMaxWidth)
                                    }
                                })
                        )
                    
                    Text("\(Int(startPoint))")
                        .foregroundColor(Color.white)
                        .offset(x: self.widthL)
                    
                }
                
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40)
                        .offset(x: self.widthH)
                    
                    Circle()
                        .fill(Color.Blue)
                        .frame(width: 35)
                        .offset(x: self.widthH)
                        .gesture(
                            DragGesture()
                                .onChanged({(value) in
                                    if value.location.x <= self.barMaxWidth && value.location.x >= self.widthL {
                                        self.widthH = value.location.x
                                        self.endPoint = self.getValue(val: (self.widthH / self.barMaxWidth))
                                    }
                                })
                        )
                    
                    Text("\(Int(endPoint))")
                        .foregroundColor(Color.white)
                        .offset(x: self.widthH)
                    
                }
            }
        }
        .baseShadowModifier()
    }
    
    func getValue(val: CGFloat) -> Int {
        let result = Double(val) * 100
        return Int(round(result))
    }
}

// 復習回数の選択部分
struct ReviewNumberInputSection: View {
    @EnvironmentObject var logVM: LogViewModel
    
    var body: some View {
        let sliderWidth:Double = FrameSize().width - horizontalPadding * 3
        VStack{
            Text("復習回数")
                .sectionTitleWithMarkModifier()
            
            Text("\(Int(logVM.reviewNumber))")
                .offset(x: -(sliderWidth / 2) + (logVM.reviewNumber * sliderWidth / 5) )
            
            Slider(
                value: $logVM.reviewNumber,
                in: 0...5,
                step: 1
            )
        }
    }
}

// 実施日時の選択部分
struct ImplementationDateInputSection: View {
    @State var date = Date()
    
    var body: some View {
        VStack{
            Text("実施日時")
                .sectionTitleWithMarkModifier()
            DatePicker(selection: $date, displayedComponents: .date, label: {Text("")})
                .datePickerStyle(WheelDatePickerStyle())
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .datePickerStyle(CompactDatePickerStyle())
                .scaleEffect(y: 0.9)
            
        }
    }
}

// 回答時間の選択部分
struct AnswerTimeInputSection: View {
    @EnvironmentObject var logVM: LogViewModel
    
    let minimumUnit: Double = 0.01
    
    var body: some View {
        VStack{
            Text("回答時間")
                .sectionTitleWithMarkModifier()
            
            HStack {
                // 目標時間の減算ボタン
                Button(action: {
                    if(logVM.targetTime >= minimumUnit){
                        logVM.subTargetTime(minimumUnit: minimumUnit)
                    }
                    print(logVM.targetTime)
                }, label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                })
                .primarySmallIconButtonModifier()
                
                Spacer()
                
                Text(TimeService().rate2min(
                    value: logVM.targetTime,
                    minimumUnit: minimumUnit
                ))
                .timerSmallTextModifier(color: Color.Gray)
                
                Spacer()
                
                // 目標時間の加算ボタン
                Button(action: {
                    logVM.addTargetTime(minimumUnit: minimumUnit)
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                })
                .primarySmallIconButtonModifier()
            }
            
            
        }
    }
    
}
