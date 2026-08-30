//
//  AuthServiceProtocol.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import Foundation
import SwiftData

protocol AuthServiceProtocol {
    func login(username: String, password: String, context: ModelContext) async throws -> User

}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid credentials"
        }
    }
}
