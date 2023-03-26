//
//  logmapApp.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/25.
//

import SwiftUI
import Firebase

@main
struct logmapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// FirebaseをAppの起動時に初期化するための処理
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
