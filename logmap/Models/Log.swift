//
//  Log.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/05.
//

import Foundation
import FirebaseFirestore

struct Log: Identifiable {
    var id: String
    var category: String
    var tergetTime: String
    var date: Double
}
