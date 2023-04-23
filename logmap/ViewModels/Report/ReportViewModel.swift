//
//  ReportViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/16.
//

import Foundation

enum TimeAllocationUnitSelection {
    case today
    case week
    case month
}

class ReportViewModel: ObservableObject {
    @Published var baseDate: Date   // スクロールの基準となる日付
    @Published var targetDate: Date // レポートを表示する日付

    @Published var dailyAchievements: [DailyAchievement]
    @Published var selectedTimeAllocation: TimeAllocationUnitSelection = .today
    
    init(){
        self.dailyAchievements = []
        self.baseDate = Date()
        self.targetDate = Date()
        dailyAchievements = self.getDaysOfWeek()
    }
    
    func changeTargetDate(newDate: Date) {
        self.targetDate = newDate
    }

    
    func changeBaseDate(newDate: Date) {
        self.baseDate = newDate
        self.dailyAchievements = self.getDaysOfWeek()
    }
    
    // 今週の日付を含む90日間分のDailyAchievementを計算して配列で返す
    func getDaysOfWeek() -> [DailyAchievement] {
        let today = self.baseDate

        var dailyAchievements = [DailyAchievement]()
        
        // グレゴリオ暦を使用するカレンダーを定義する
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: today)
        let daysToSaturday = (7 - (components.weekday ?? 0)) % 7
        let saturday = calendar.date(byAdding: .day, value: daysToSaturday, to: today)!
        
        // 90日分のDailyAchievementを作成する
        for i in 0..<90 {
            // 日付を計算し、その日の曜日を取得する
            if let date = calendar.date(byAdding: .day, value: -i, to: saturday) {
                
                // 日付を曜日の文字列に変換する
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateFormat = "EEE"
                let weekdayString = dateFormatter.string(from: date)
                
                // DailyAchievementを作成して配列に追加する
                let dailyAchievement = DailyAchievement(
                    date: date,
                    dayOfWeek: weekdayString,
                    achievementRate: 0.8
                )
                dailyAchievements.insert(dailyAchievement, at: 0)
            }
        }
        
        //print("dailyAchievements: \(dailyAchievements)")
        
        return dailyAchievements
    }
    

    // TimeAllocationを.todayに変更
    func todaySelected() {
        self.selectedTimeAllocation = .today
    }
    
    // TimeAllocationを.weekに変更
    func weekSelected() {
        self.selectedTimeAllocation = .week
    }
    
    // TimeAllocationを.monthに変更
    func monthSelected() {
        self.selectedTimeAllocation = .month
    }
}
