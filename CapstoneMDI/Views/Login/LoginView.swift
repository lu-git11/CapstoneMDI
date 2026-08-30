//
//  LoginView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    @Environment(\.modelContext) private var modelContext
        
    init(authService: AuthServiceProtocol = AuthService()) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }
    
    var body: some View {
        NavigationStack {
            ZStack{ Background.gradient3.ignoresSafeArea()
                VStack(spacing: 16) {
                    HeaderView(title: "Login", subtitle: "Enter your login", icon: "wallet.bifold.fill"
                    )
                    
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("username_field")
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("password_field")
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .accessibilityIdentifier("error_label")
                    }
                    
                    Button {
                        Task { await viewModel.login(context: modelContext) }
                    } label: {
                        Text("Login")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .padding(10)
                            .padding(.horizontal, 20)
                            .background(Color(hex: "#FE7743"))
                            .cornerRadius(10)
                     
                    }
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Sign Up Now")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .padding(10)
                            .padding(.horizontal, 20)
                            .background(Color(.cyan))
                            .cornerRadius(10)
                     
                    }
                }
                .padding(20)
                .navigationDestination(item: $viewModel.loggedIn) { user in
                    WelcomeView(user: user, onLogout: { viewModel.logout()
                    })
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

 
