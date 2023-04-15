//
//  CommonModifier.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/15.
//

import SwiftUI

struct BaseShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .Gray.opacity(0.25),
                radius: 5,
                x: 5,
                y: 5
            )
    }
}

extension View {
    func baseShadowModifier() -> some View {
        modifier(BaseShadow())
    }
}

