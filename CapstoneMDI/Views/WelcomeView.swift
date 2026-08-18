//
//  WelcomeView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import SwiftUI

struct WelcomeView: View {
    let user: User
    let onLogout: () -> Void
    
    @State private var navigateToWorkout = false
    
    var body: some View {
        NavigationStack {
            ZStack { Background.gradient3.ignoresSafeArea()
                NavigationLink(isActive: $navigateToWorkout) {
                    DashboardView()
                } label: {
                    EmptyView()
                }
                
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 90)).foregroundStyle(.green)
                    
                    Text("Welcome, \(user.name)")
                        .font(.largeTitle.bold())
                }
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    navigateToWorkout = true
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView(
        user: User(username: "test", name: "test", password: "password"),
        onLogout: {}
    )
}


