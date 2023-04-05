//
//  NavigationViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/04.
//

import Foundation

enum NView {
    case second, third
}

class NavigationViewModel: ObservableObject {
    @Published var navigationPath = [NView]()
    
    func popToRoot() {
            navigationPath = []
    }
}
