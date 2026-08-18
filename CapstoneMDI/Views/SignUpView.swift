//
//  SignUpView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    // Local form state
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    // SwiftData model context (if your project uses SwiftData)
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var isPasswordValid: Bool {
        let minCount = password.count >= 8
        let letterRule = password.rangeOfCharacter(from: .letters) != nil
        return minCount && letterRule
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Background.gradient2.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    if !password.isEmpty && !isPasswordValid {
                        Text("Password must be atleast 8 characters and contain a letter")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                    
                    Button("Create Account", action: performSignup)
                        .buttonStyle(.borderedProminent)
                        .disabled(username.isEmpty || password.isEmpty || !isPasswordValid)
                }
                .padding()
            }
        }
    }
    
    private func performSignup() {
        // Adjust `UserModel` initializer/fields to match your data model.
        let newUser = User(
            username: username,
            name: name,
            password: password
        )
        
        modelContext.insert(newUser)
        do {
            try modelContext.save()
            print("User created")
            // Optionally clear the form
            name = ""
            username = ""
            password = ""
            
            dismiss()
            
        } catch {
            print("Error creating user: \(error)")
        }
    }
}

#Preview {
    SignUpView()
}
