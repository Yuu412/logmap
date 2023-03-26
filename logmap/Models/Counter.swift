//
//  Counter.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import Foundation

struct Counter {
    var value: Int = 0
    var isPremium: Bool = false
    
    mutating func increment() {
        value += 1
        
        if value.isMultiple(of: 3) {
            // premium
            isPremium = true
        } else {
            // not premium
            isPremium = false
        }
    }
}
