//
//  UserModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import Foundation
import Combine
import SwiftData
import CryptoKit

@Model
final class User: Hashable, Identifiable {
    var id : UUID
    var username: String
    var name: String
    var password: String
    var reviews: [Review] = []
    
    init(username: String, name: String, password: String) {
        self.id = UUID()
        self.username = username
        self.name = name
        self.password = password
    }
    
    static func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
}


