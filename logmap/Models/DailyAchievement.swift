//
//  DailyAchievement.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/18.
//

import Foundation

struct DailyAchievement: Hashable, Equatable {
    var date: Date
    var dayOfWeek: String
    var achievementRate: Double
}
