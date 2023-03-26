//
//  LogViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/26.
//

import Foundation
import Firebase

class LogViewModel: ObservableObject {
    @Published var textbooks: [Textbook] = []
    
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
}
