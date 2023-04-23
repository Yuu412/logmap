//
//  ReportScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

struct ReportScreen: View{
    @StateObject var navigationVM = NavigationViewModel()
    @ObservedObject var reportVM = ReportViewModel()
    
    var body: some View{
        ZStack {
            Color.BackgroundGray.ignoresSafeArea()
            VStack{
                ReportPageTitleSection()
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        DatePickerSection()
                        
                        GoalCheckSection()
                            .frame(width: FrameSize().width * 0.9)
                        
                        LatestLogsSection()
                            .frame(width: FrameSize().width * 0.9)
                        
                        TimeAllocationSection()
                            .frame(width: FrameSize().width * 0.9)
                        
                        Spacer()
                    }
                }
                .padding(.top, 10)
            }
        }
        .environmentObject(reportVM)
        .onAppear(){
            navigationVM.safeAreaBackground = Color.BackgroundGray
        }
    }
}

struct ReportPageTitleSection: View{
    @State var isOpenCalendar: Bool = false
    @EnvironmentObject var reportVM: ReportViewModel
    
    var body: some View{
        HStack(){
            Text("レポート")
                .modifier(PageTitle())
            Spacer()
            
            ZStack{
                Button (action: {
                    isOpenCalendar.toggle()
                }, label: {
                    VStack{
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(isOpenCalendar == true ? Color.Blue : Color.gray)
                    }
                })
                .sheet(isPresented: $isOpenCalendar) {
                    
                    CustomDatePicker()
                        .environmentObject(self.reportVM)
                        .presentationDetents([.height(FrameSize().height * 0.6)])
                    
                }
            }
        }
        .padding()
    }
}

// 日付の選択部分
struct DatePickerSection: View{
    @EnvironmentObject var reportVM: ReportViewModel
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(reportVM.dailyAchievements, id: \.self) { dailyAchievement in
                    Button (action: {
                        reportVM.changeTargetDate(newDate: dailyAchievement.date)
                    }, label: {
                        VStack{
                            Text(dailyAchievement.dayOfWeek)
                                .smallTextModifier()
                                .foregroundColor(Color.Gray)
                            
                            DateProgressCircular(
                                progressValue: CGFloat(dailyAchievement.achievementRate),
                                contentText: dateFormatter.string(from: dailyAchievement.date),
                                reverseColor: reportVM.targetDate == dailyAchievement.date ? true : false
                            )
                        }
                    })
                }
            }
            .padding(.bottom, 10)
            .padding(.trailing, 16)
            .rotationEffect(.degrees(180))
        }
        .rotationEffect(.degrees(180))
        
    }
    
}


// 今日のゴールの確認部分
struct GoalCheckSection: View{
    @EnvironmentObject var reportVM: ReportViewModel
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年M月d日"
        return dateFormatter
    }()
    
    @State var progressValue: CGFloat = 0.3
    
    var body: some View{
        VStack{
            
            HStack(alignment: .bottom) {
                Text("今日の勉強量")
                    .sectionTitlePlainModifier()
                
                Text(dateFormatter.string(from: reportVM.targetDate))
                    .smallTextModifier()
                
                Spacer()
            }
            
            HStack {
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
        .padding()
        .background(Color.white)
        .baseCardModifier()
    }
}

// 最近のログ表示部分
struct LatestLogsSection: View{
    @EnvironmentObject var reportVM: ReportViewModel
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年M月d日"
        return dateFormatter
    }()
    
    var body: some View{
        VStack{
            HStack(alignment: .bottom) {
                Text("今日の勉強量")
                    .sectionTitlePlainModifier()
                
                Text(dateFormatter.string(from: reportVM.targetDate))
                    .smallTextModifier()
                Spacer()
                
                Button (action: {
                    print("全て表示")
                }, label: {
                    HStack{
                        Text("すべてを表示")
                            .smallTextModifier()
                            .foregroundColor(Color.Blue)
                        
                        Image(systemName: "chevron.right")
                    }
                })
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10) { _ in
                        VStack(spacing: 8) {
                            Image("Focus Gold 数学I＋A")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: FrameSize().height * 0.175)
                            
                            Text("Focus Gold 数学I＋A")
                                .smallTextModifier()
                            
                            HStack{
                                Text("20min")
                                    .timeTextModifier()
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
            
        }
        .padding(.vertical, 25)
    }
}

var tmpSubjects: [PerTimeAllocation] = [
    PerTimeAllocation(
        subject: "数学",
        color: Color.blue,
        hour: 8
    ),
    PerTimeAllocation(
        subject: "英語",
        color: Color.yellow,
        hour: 4
    ),
    PerTimeAllocation(
        subject: "物理",
        color: Color.purple,
        hour: 7
    ),
    PerTimeAllocation(
        subject: "生物",
        color: Color.orange,
        hour: 2
    ),
    
]

// 時間の配分
struct TimeAllocationSection: View{
    var body: some View{
        VStack() {
            HStack(alignment: .bottom) {
                Text("勉強時間の配分")
                    .sectionTitlePlainModifier()
                Spacer()
            }
            
            // 時間配分の集計単位を変更するタブ
            TimeAllocationUnitPicker()
            
            // 時間配分の円グラフ
            TimeAllocationCircular(subjects: tmpSubjects)
            
            // 教科毎の時間表示
            TimeAllocationList()
            
        }
        .padding()
        .background(Color.white)
        .baseCardModifier()
    }
}

// 時間の単位を「今日・今週・今月」から選択
struct TimeAllocationUnitPicker: View{
    @EnvironmentObject var reportVM: ReportViewModel
    
    var body: some View{
        HStack {
            Button (action: {
                reportVM.todaySelected()
            }, label: {
                Text("今日")
                    .smallTextModifier()
                    .foregroundColor(reportVM.selectedTimeAllocation == TimeAllocationUnitSelection.today ? Color.white : Color.Gray)
                    .padding(.vertical, 12.5)
                    .padding(.horizontal, 35)
                    .background(reportVM.selectedTimeAllocation == TimeAllocationUnitSelection.today ? Color.Blue : Color.BackgroundGray)
                    .cornerRadius(99)
            })
            Spacer()
            
            Button (action: {
                reportVM.weekSelected()
            }, label: {
                Text("今週")
                    .smallTextModifier()
                    .foregroundColor(reportVM.selectedTimeAllocation == TimeAllocationUnitSelection.week ? Color.white : Color.Gray)
                    .padding(.vertical, 12.5)
                    .padding(.horizontal, 35)
                    .background(reportVM.selectedTimeAllocation == TimeAllocationUnitSelection.week ? Color.Blue : Color.BackgroundGray)
                    .cornerRadius(99)
            })
            
            Spacer()
            
            Button (action: {
                reportVM.monthSelected()
            }, label: {
                Text("今月")
                    .smallTextModifier()
                    .foregroundColor(reportVM.selectedTimeAllocation == TimeAllocationUnitSelection.month ? Color.white : Color.Gray)
                    .padding(.vertical, 12.5)
                    .padding(.horizontal, 35)
                    .background(reportVM.selectedTimeAllocation == TimeAllocationUnitSelection.month ? Color.Blue : Color.BackgroundGray)
                    .cornerRadius(99)
            })
        }
        .foregroundColor(Color.Gray)
        .smallTextModifier()
        .background(Color.BackgroundGray)
        .cornerRadius(99)
        .padding(.vertical, 15)
    }
    
}

// 教科毎の時間表示
struct TimeAllocationList: View{
    @EnvironmentObject var reportVM: ReportViewModel
    
    var body: some View{
        VStack {
            ForEach(tmpSubjects, id: \.self) { subject in
                HStack {
                    Circle()
                        .foregroundColor(subject.color)
                        .frame(width: 15)
                    
                    VStack{
                        Text(subject.subject)
                            .baseTextModifier()
                            .fontWeight(.medium)
                            .foregroundColor(Color.Gray)
                        Text("38%")
                            .smallTextModifier()
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()
                    
                    Button (action: {
                        print("全て表示")
                    }, label: {
                        HStack{
                            Text("\(String(subject.hour))時間")
                                .baseTextModifier()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Gray)
                    })
                }
                .padding(.vertical, 5)
            }
            Spacer()
            
            Button (action: {
                print("全て表示")
            }, label: {
                HStack {
                    Text("もっと見る")
                        .baseTextModifier()
                    Image(systemName: "chevron.down")
                }
            })
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

struct ReportScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportScreen()
    }
}
