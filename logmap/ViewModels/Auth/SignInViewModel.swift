//
//  SignInViewModel.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/26.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import Firebase
import FirebaseAuth

class SignInViewModel: ObservableObject {
    
    // 検証用（ログインを無効化）
    //@AppStorage("log_status") var log_Status = true
    
    // 本番用
    @AppStorage("log_status") var log_Status = false
    
    @Published var nonce = ""
    
    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        guard let token = credential.identityToken else {
            print("error with Firebase")
            return
        }
        
        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        // Initialize a Firebase credential.
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
        
        // User Successfully logged into Firebase...
        print("Sign In Success")
        
        // Directing User To Home Page...
        withAnimation(.easeInOut) {
            self.log_Status = true
        }
        
    }
}

// Apple Sign in with Firebase の helpers
// https://firebase.google.com/docs/auth/ios/apple?authuser=0
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}
