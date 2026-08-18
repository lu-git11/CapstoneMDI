//
//  OnboardingView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("seenWelcomeView") private var seenWelcomeView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Background.gradient2.ignoresSafeArea()
                VStack {
                    Text("Onboarding")
                    
                    Spacer()
                    
                    Button(action: { seenWelcomeView = true }) {
                        Text("Get started")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .foregroundStyle(.white)
                            .background(Color(hex: "#fe7743"))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
