//
//  ContentView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

struct ContentView: View {
    // 本番用
    //@AppStorage("log_status") var log_Status = false
    
    // Dev
    @AppStorage("log_status") var log_Status = true
    @State private var selection = 2
    @ObservedObject var contentVM = ContentViewModel()
    @ObservedObject var logVM = LogViewModel()
    
    @StateObject var navigationVM = NavigationViewModel()
    
    init(){
        if !contentVM.isTabView {
            UITabBar.appearance().isHidden = true
        }
    }
    
    var body: some View {
        if self.log_Status {
            NavigationStack(path: $navigationVM.navigationPath) {
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
                .environmentObject(contentVM)
                .navigationDestination(for: NavView.self) { path in
                    switch path{
                    case .recordScreen: RecordScreen().environmentObject(logVM)
                    case .stopWatchView: StopWatchView().environmentObject(logVM)
                    case .enterLogImageView: EnterLogImageView().environmentObject(logVM)
                    }
                }
            }
            .environmentObject(navigationVM)
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
