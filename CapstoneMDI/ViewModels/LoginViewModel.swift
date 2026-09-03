//
//  LoginViewModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var loggedIn: User?
    
    private let authService : AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(context: ModelContext) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            loggedIn = try await authService.login(
                username: username,
                password: password,
                context: context)
            Reminder.scheduleLoginReminderIfNeeded()
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func logout() {
        loggedIn = nil
        username = ""
        password = ""
    }
}
