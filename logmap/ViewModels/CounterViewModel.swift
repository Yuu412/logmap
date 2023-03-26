//
//  CounterViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import Foundation
import SwiftUI

class CounterViewModel: ObservableObject {
    @Published private var counter:Counter = Counter()
    
    var value: Int {
        counter.value
    }
    
    var premium: Bool {
        counter.isPremium
    }
    
    func increment() {
        counter.increment()
    }
}
