//
//  ContentView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("log_status") var log_Status = false
    
    @State private var selection = 2
    var body: some View {
        if self.log_Status {
            TabView(selection:$selection) {
                Spacer()
                ReportScreen()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        //Label("レポート", systemImage: "chart.bar.fill")
                    }
                    .tag(1)
                LogScreen()
                    .tabItem {
                        Image("map")
                        
                    }
                    .tag(2)
                MypageScreen()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        //Label("マイページ", systemImage: "person.crop.circle")
                    }
                    .tag(3)
                Spacer()
            }
            .padding()
        }
        else {
            // サインイン用ページ
            SignInScreen().modifier(BaseText())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
