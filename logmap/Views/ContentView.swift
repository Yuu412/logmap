//
//  ContentView.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI

struct TabItem: Hashable {
    let id = UUID()
    let imageName: String
    let label: String
}

let tabs = ["doc.text.magnifyingglass", "chart.bar.fill", "person.crop.circle"]

let tabItems = [
    TabItem(imageName: "doc.text.magnifyingglass", label: "レポート"),
    TabItem(imageName: "chart.bar.fill", label: "ログ"),
    TabItem(imageName: "person.crop.circle", label: "設定")
]

struct ContentView: View {
    // 本番用
    //@AppStorage("log_status") var log_Status = false
    
    // Dev
    @AppStorage("log_status") var log_Status = true
    @State var selectedTab = tabItems[1]
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
                ZStack{
                    TabView(selection: $selectedTab) {
                        ReportScreen()
                            .tag(tabItems[0])
                        
                        LogScreen()
                            .tag(tabItems[1])
                        
                        MypageScreen()
                            .tag(tabItems[2])
                    }
                    .environmentObject(contentVM)
                    .navigationDestination(for: NavView.self) { path in
                        switch path{
                        case .recordScreen: RecordScreen().environmentObject(logVM)
                        case .stopWatchView: StopWatchView().environmentObject(logVM)
                        case .enterLogImageView: EnterLogImageView().environmentObject(logVM)
                        }
                    }
                    
                    CustomNavigation(selectedTab: self.$selectedTab)
                }
                .padding()
                .ignoresSafeArea(.all, edges: .bottom)
            }
            .environmentObject(navigationVM)
        }
        else {
            // サインイン用ページ
            SignInScreen().modifier(BaseText())
        }
    }
}

// Navigation
struct CustomNavigation: View{
    @Binding var selectedTab: TabItem
    
    var body: some View{
        VStack{
            Spacer()
            
            HStack(spacing: 0){
                ForEach(tabItems, id:\.self) { tabItem in
                    Button (action: {
                        withAnimation(.spring()){
                            selectedTab = tabItem
                        }
                    }, label: {
                        VStack{
                            Image(systemName: tabItem.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedTab == tabItem ? Color.Blue : Color.gray)
                            Text(tabItem.label)
                                .smallTextModifier()
                                .foregroundColor(selectedTab == tabItem ? Color.Blue : Color.Gray)
                        }
                    })
                    
                    if tabItem.imageName != tabs.last{Spacer(minLength: 0)}
                }
                
            }
            .padding(.horizontal, FrameSize().width * 0.125)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(
                color: .black.opacity(0.25),
                radius: 5,
                x: 5,
                y: 5
            )
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
