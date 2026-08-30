//
//  ExerciseModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/18/26.
//

import Foundation
import SwiftData

@Model
final class Exercise: Identifiable {
    var id: UUID
    var name: String
    var targetSets: Int
    var targetReps: Int
    var order: Int
    var section: String?
    var user: User?
    var userID: UUID
    
    init(
        name: String,
        targetSets: Int,
        targetReps: Int,
        order: Int = 0,
        section: String? = nil,
        user: User? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.targetSets = targetSets
        self.targetReps = targetReps
        self.order = order
        self.section = section
        self.user = user
        self.userID = user?.id ?? UUID()
    }
}
