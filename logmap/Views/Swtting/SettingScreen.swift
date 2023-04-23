//
//  MypageScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI
import FirebaseAuth

struct SettingScreen: View{
    @StateObject var navigationVM = NavigationViewModel()

    @AppStorage("log_status") var log_Status = false
    var body: some View{
        ScrollView {
            VStack {
                Button(action: {
                    DispatchQueue.global(qos: .background).async {
                        try? Auth.auth().signOut()
                    }
                    
                    withAnimation(.easeOut){
                        log_Status = false
                    }
                    
                }, label: {
                    Text("ログアウト")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.Blue)
                        .clipShape(Capsule())
                })
                
                Spacer()
            }
        }
        .padding(.top, 10)
    }
}
