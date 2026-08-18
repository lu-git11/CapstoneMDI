//
//  AuthService.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    private let validUsername = "Username"
    private let validPassword = "password"
    
    func login(username: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        guard username == validUsername, password == validPassword else {
            throw AuthError.invalidCredentials
        }
        return User(username: username, name: "test", password: "password")
    }
}
