//
//  TextModifier.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

struct PageTitle: ViewModifier {
    let uiFont = UIFont(name: "HiraginoSans-W6", size: 24)!
    func body(content: Content) -> some View {
        content
            .font(.custom("HiraginoSans-W6", size: 24))
            .foregroundColor(Color.Black)
            .lineSpacing(16)
            .kerning(2)
            .baselineOffset(-uiFont.descender)
        
    }
}

// 「>」が先頭に付くSectionTitle
struct SectionTitle: ViewModifier {
    let uiFont = UIFont(name: "HiraginoSans-W3", size: 16)!
    func body(content: Content) -> some View {
        HStack{
            Image(systemName: "chevron.right")
            content
                .font(.custom("HiraginoSans-W6", size: 16))
                .foregroundColor(Color.Gray)
                .lineSpacing(14)
                .kerning(1)
                .padding(.top, 3)
                .baselineOffset(-uiFont.descender)

        }
    }
}

// 「●」が先頭に付くSectionTitle
struct SectionTitleWithMark: ViewModifier {
    let uiFont = UIFont(name: "HiraginoSans-W3", size: 16)!
    func body(content: Content) -> some View {
        HStack{
            Image("preTitleMark")
                .resizable()
                .frame(width: 16, height: 16)
            content
                .font(.custom("HiraginoSans-W6", size: 16))
                .foregroundColor(Color.Gray)
                .lineSpacing(14)
                .kerning(1)
                .padding(.top, 3)
                .baselineOffset(-uiFont.descender)
            Spacer()
        }
    }
}

struct SubheadlineText: ViewModifier {
    let uiFont = UIFont(name: "HiraginoSans-W3", size: 18)!
    func body(content: Content) -> some View {
        HStack{
            content
                .font(.custom("HiraginoSans-W3", size: 18))
                .lineSpacing(10)
                .baselineOffset(-uiFont.descender)
        }
    }
}

struct BaseText: ViewModifier {
    let uiFont = UIFont(name: "HiraginoSans-W3", size: 14)!
    func body(content: Content) -> some View {
        HStack{
            content
                .font(.custom("HiraginoSans-W3", size: 14))
                .lineSpacing(10)
                .baselineOffset(-uiFont.descender)
        }
    }
}

struct PageHeadline: ViewModifier {
    let color: Color
    let uiFont = UIFont(name: "HiraginoSans-W6", size: 24)!
    func body(content: Content) -> some View {
        content
            .font(.custom("HiraginoSans-W6", size: 24))
            .foregroundColor(color)
            .lineSpacing(16)
            .kerning(2)
            .baselineOffset(-uiFont.descender)
        
    }
}

// タイマー表示時の時間表示部
struct TimerText: ViewModifier {
    let color: Color
    let uiFont = UIFont(name: "HiraginoSans-W3", size: 60)!
    
    func body(content: Content) -> some View {
        HStack{
            content
                .font(.custom("HiraginoSans-W3", size: 60))
                .baselineOffset(-uiFont.descender)
                .foregroundColor(color)
        }
    }
}

// タイマー表示時の時間表示部
struct TimerSmallText: ViewModifier {
    let color: Color
    let uiFont = UIFont(name: "HiraginoSans-W3", size: 48)!
    
    func body(content: Content) -> some View {
        HStack{
            content
                .font(.custom("HiraginoSans-W3", size: 48))
                .baselineOffset(-uiFont.descender)
                .foregroundColor(color)
        }
    }
}

extension View {
    
    func sectionTitleModifier() -> some View {
        modifier(SectionTitle())
    }
    
    func sectionTitleWithMarkModifier() -> some View {
        modifier(SectionTitleWithMark())
    }
    
    func pageTitleModifier() -> some View {
        modifier(PageTitle())
    }
    
    func subheadlineTextModifier() -> some View {
        modifier(SubheadlineText())
    }
    
    func baseTextModifier() -> some View {
        modifier(BaseText())
    }
    
    func timerHeadlineModifier(color: Color) -> some View {
        modifier(PageHeadline(color: color))
    }
    
    func timerTextModifier(color: Color) -> some View {
        modifier(TimerText(color: color))
    }
    
    func timerSmallTextModifier(color: Color) -> some View {
        modifier(TimerSmallText(color: color))
    }
}


