//
//  NavigationViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/04.
//

import Foundation
import SwiftUI

enum NavView {
    // case
    case recordScreen,    // RecordScreen()
         stopWatchView,      // StopWatchView()
         enterLogImageView
}

class NavigationViewModel: ObservableObject {
    @Published var navigationPath = [NavView]()
    
    @Published var safeAreaBackground: Color = Color.white
    
    func popToRoot() {
            navigationPath = []
    }
}
