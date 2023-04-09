//
//  NavigationViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/04.
//

import Foundation

enum NavView {
    // case
    case recordScreen,    // RecordScreen()
         stopWatchView,      // StopWatchView()
         enterLogImageView
}

class NavigationViewModel: ObservableObject {
    @Published var navigationPath = [NavView]()
    
    func popToRoot() {
            navigationPath = []
    }
}
