//
//  LoginView.swift
//  Dimple
//
//  Created by Adrian on 20/08/2024.
//

import SwiftUI
import Observation
import AuthenticationServices

struct AuthUser: Codable {
    let id: String
    let token: String
    let refreshToken: String
    let onboardingFinished: String?
//    var name: String?
//    var lastName: String?
//    var email: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case token
        case refreshToken = "refresh_token"
        case onboardingFinished = "onboarding_finished"
//        case name = "full_name"
//        case lastName = "last_name"
//        case email
    }
    
}


@Observable
final class AuthViewModel {
    
    var user: AuthUser?
    var errorMessage: String?

    func loadUser(token: String, userData: String) async {
        
        let url = "https://api.dimple.dating/v1/auth/apple"
        let body = ["code" : token, "user" : userData]
        
        do {
            user = try await NetworkManager.shared.fetch(urlString: url, method: .POST, body: body)
        } catch {
            errorMessage = "Failed to load data: \(error)"
        }
    }
}


struct LoginView: View {
    
    @Bindable private var viewModel = AuthViewModel()
    
    @AppStorage("token") var appToken: String = ""
    @AppStorage("refreshToken") var refreshToken: String = ""
    @AppStorage("onboardingFinished") var onboardingFinished: Bool = false
    
    @State private var showOnboarding: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Spacer()
                
                Image(.dimpleLogoBlack)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260)
                    .clipped()
                
                Spacer()
                
                ZStack {
                    
                    //                Button(action: {
                    //
                    //                }, label: {
                    //
                    //                    Text(" Sign in with Apple")
                    //                        .font(.system(size: 18, weight: .semibold))
                    //                        .foregroundStyle(.black)
                    //                        .frame(width: 320, height: 44)
                    //                        .overlay {
                    //                            Capsule()
                    //                                .stroke(lineWidth: 1)
                    //                                .foregroundStyle(.black)
                    //                        }
                    //
                    //                })
                    
                    SignInWithAppleButton(.signUp) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            handleSuccessfulLogin(with: authorization)
                        case .failure(let error):
                            handleLoginError(with: error)
                        }
                    }
                    .frame(width: 320, height: 44)
                    
                }
                .padding(.bottom)
                
                Text("By proceeding, you agree to both Dimple\nPrivacy Policy and Terms of Service.")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                
            }
            .padding(.horizontal)
            .background(
                NavigationLink("", destination: OnboardingView().toolbar(.hidden), isActive: $showOnboarding)
                    .hidden()
            )
            .toolbar(.hidden)
        }
        
    }
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
            if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                guard let tokenData = userCredential.identityToken else { return }
                guard let token = String(data: tokenData, encoding: .utf8) else { return }
                
                Task {
                    await viewModel.loadUser(token: token, userData: userCredential.user)
                    appToken = viewModel.user?.token ?? ""
                    refreshToken = viewModel.user?.refreshToken ?? ""
                    onboardingFinished = ((viewModel.user?.onboardingFinished ?? "") == "true")
                    showOnboarding = ((viewModel.user?.onboardingFinished ?? "") != "true")
                    print("TOKEN = \(appToken)")
                    print("REFRESH TOKEN = \(refreshToken)")
                }
            }
        }
        
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \\(error.localizedDescription)")
    }
    
}

#Preview {
    LoginView()
}
