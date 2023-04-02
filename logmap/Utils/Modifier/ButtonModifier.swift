//
//  ButtonModifier.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/02.
//

import SwiftUI

// 背景色: Primary, 内容：Icon
struct PrimaryIconButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50)
            .background(Color.Blue)
            .cornerRadius(30.0)
            .shadow(color: .gray, radius: 3, x: 3, y: 3)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))

    }
}

// 背景色: Primary, 内容：Text, 大きさ：dafault
struct PrimaryTextButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack{
            content
                .padding(.horizontal, 48)
                .padding(.vertical, 10)
                .foregroundColor(Color.white)
                .background(Color.Blue)
                .font(.system(size: 24))
                .kerning(2)
                .fontWeight(.medium)
                .cornerRadius(99)
        }
    }
}

// 背景色: Primary, 内容：Text, 大きさ：小
struct SmallPrimaryTextButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack{
            content
                .padding(.horizontal, 32)
                .padding(.vertical, 6)
                .foregroundColor(Color.white)
                .background(Color.Blue)
                .font(.system(size: 18))
                .kerning(2)
                .fontWeight(.medium)
                .cornerRadius(99)
        }
    }
}


extension View {
    func primaryIconButtonModifier() -> some View {
        modifier(PrimaryIconButtonModifier())
    }
    
    func primaryTextButtonModifier() -> some View {
        modifier(PrimaryTextButtonModifier())
    }
    
    func smallPrimaryTextButtonModifier() -> some View {
        modifier(SmallPrimaryTextButtonModifier())
    }
}

