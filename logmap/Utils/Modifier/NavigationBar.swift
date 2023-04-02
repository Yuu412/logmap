//
//  NavigationBar.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/04/01.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    let navigationBarTitle: String
    let navigationBarLeading: Bool
    let navigationBarTrailing: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert = false
    
    init(navigationBarTitle: String, navigationBarLeading: Bool, navigationBarTrailing: Bool) {
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarLeading = navigationBarLeading
        self.navigationBarTrailing = navigationBarTrailing
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
        
        // [2]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(navigationBarTitle)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if navigationBarLeading {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 16, weight: .medium))
                                Text("戻る")
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
                if navigationBarTrailing {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button(action: {
                            self.showingAlert = true
                        }) {
                            HStack {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("確認"),
                                  message: Text("入力中のコンテンツは破棄されます。閉じてもよろしいですか？"),
                                  primaryButton: .cancel(Text("キャンセル")),
                                  secondaryButton: .destructive(
                                    Text("OK"), action: {
                                        dismiss()
                                    })
                            )
                        }
                    }
                }
            }
    }
}

struct ReverseNavigationBarModifier: ViewModifier {
    let navigationBarTitle: String
    @Environment(\.dismiss) var dismiss
    
    init(navigationBarTitle: String) {
        self.navigationBarTitle = navigationBarTitle
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // [2]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(navigationBarTitle)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 16, weight: .medium))
                            Text("戻る")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
    }
}

extension View {
    // Navigation
    func navigationBar(title: String, leading: Bool, trailing: Bool) -> some View {
        modifier(NavigationBarModifier(
            navigationBarTitle: title,
            navigationBarLeading: leading,
            navigationBarTrailing: trailing
        ))
    }
    
    
    // Navigation(背景色あり)
    func reverseNavigationBar(title: String) -> some View {
        modifier(ReverseNavigationBarModifier(navigationBarTitle: title))
    }
}
