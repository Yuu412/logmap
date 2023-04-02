//
//  ContentViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/02.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    // TabViewの表示/非表示の切り替え
    @Published var isTabView: Bool
    init() {
        self.isTabView = true
    }
    
    func Toggle() {
        self.isTabView.toggle()
        print(isTabView)
    }

}
