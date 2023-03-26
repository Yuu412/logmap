//
//  LoginScreen.swift
//  logmap
//
//  Created by 吉田裕哉 on 2023/03/26.
//

import SwiftUI
import AuthenticationServices

struct SignInScreen: View{
    
    @StateObject var signInData = SignInViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "character.textbox")
                .resizable()
                .scaledToFit()
                .frame(width: FrameSize().width * 0.2)
                .foregroundColor(Color.Blue)
                .padding(EdgeInsets(
                    top: FrameSize().height * 0.1,
                    leading: 0,
                    bottom: 25,
                    trailing: 0
                ))
            
            Text("logmap")
                .modifier(PageTitle())
                .padding(.vertical, 10)

            Text("学習支援サービスです。")
                .frame(width: FrameSize().width * 0.8)
            
            
            Spacer()
            
            // Sign in with apple ボタン
            SignInWithAppleButton{ (request) in
                signInData.nonce = randomNonceString()
                request.requestedScopes = [.email, .fullName]
                
            } onCompletion: { (result) in
                switch result {
                case .success(let user):
                    print("success")
                    
                    guard let credential = user.credential as?
                            ASAuthorizationAppleIDCredential else {
                        print("error with firebase")
                        return
                    }
                    signInData.authenticate(credential: credential)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .frame(height: 55)
            .clipShape(Capsule())
            .padding(.horizontal, 30)
            .offset(y: -(FrameSize().height * 0.05))

        }
    }
    
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
