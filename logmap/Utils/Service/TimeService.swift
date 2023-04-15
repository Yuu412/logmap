//
//  TimeService.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/09.
//

import Foundation

class TimeService {
    // 割合（1時間:100%）を分に変換
    func rate2min(value: Double, minimumUnit: Double) -> String {
        var retValue: String
        var roundedMinute: Int
        
        roundedMinute = Int((100 * value).rounded())
        retValue = String(format: "%02d:00", roundedMinute)
        
        return retValue
    }
    
    // 割合（1時間:100%）を分に変換
    func rate2sec(value: Double) -> String {
        var retValue: String
        var roundedMinute: Int
        
        roundedMinute = Int(100 * value) / 60
        let roundedSecond = Int(100 * value) % 60
        
        retValue = String(format: "%02d:%02d", roundedMinute, roundedSecond)
        
        return retValue
    }
}
