//
//  DateValue.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/23.
//

import SwiftUI

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
