//
//  LogViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/26.
//

import Foundation
import FirebaseFirestore

enum stopWatchMode{
    case start
    case stop
    case pause
}

class LogViewModel: ObservableObject {
    @Published var textbooks: [Textbook] = []
    @Published var targetTime: CGFloat = INFINITESIMAL
    @Published var progressTime: CGFloat = INFINITESIMAL
    
    @Published var mode:stopWatchMode = .start
    
    var timer = Timer()
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("textbooks").getDocuments { snapshot, err in
            if err == nil {
                // No error
                
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.textbooks = snapshot.documents.map { doc in
                            return Textbook(
                                id: doc.documentID,
                                category: doc["category"] as? String ?? "",
                                title: doc["title"] as? String ?? "",
                                cover: doc["cover"] as? String ?? ""
                            )
                        }
                    }
                }
            }
            else {
                // エラー処理
            }
        }
    }
    
    func addTargetTime(minimumUnit: Double) {
        self.targetTime += minimumUnit
    }
    
    func subTargetTime(minimumUnit: Double) {
        print(self.targetTime)
        self.targetTime -= minimumUnit
    }
    
    func resetTargetTimeRate(){
        self.targetTime = INFINITESIMAL
    }
    
    func timerStart() {
        mode = .start
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            self.progressTime += 0.01
        }
    }
    
    func timerPause() {
        mode = .pause
        timer.invalidate()
    }
    
    func timerStop() {
        timer.invalidate()
        self.progressTime = 0
        mode = .stop
    }
    
    
}
