//
//  AuthService.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import Foundation
import SwiftData

final class AuthService: AuthServiceProtocol {
//    private let validUsername = "Username"
//    private let validPassword = "password"
    
    func login(username: String, password: String, context: ModelContext) async throws -> User {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        let hashedPassword = User.hashPassword(password)
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.username == username }
        )
        
        guard  let user = try context.fetch(descriptor).first,
               user.password == hashedPassword else {
            throw AuthError.invalidCredentials
        }
        return user
    }
}
