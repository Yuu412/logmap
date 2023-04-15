//
//  CardModifier.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/11.
//

import SwiftUI

struct BaseCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .shadow(
                color: .Gray.opacity(0.25),
                radius: 5,
                x: 5,
                y: 5
            )
    }
}

extension View {
    func baseCardModifier() -> some View {
        modifier(BaseCard())
    }
}

