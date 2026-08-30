//
//  RoutineModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/25/26.
//

import Foundation
import SwiftData

@Model
final class Routine: Identifiable {
    var id: UUID
    var title: String
    var coach: String
    var summary: String
    var image: String
    
    var rating: Int? = nil
    
    var user: User?
    var userID: UUID
    
    init(
        title: String,
        coach: String = "",
        summary: String = "",
        image: String = "push",
        rating: Int? = nil,
        user: User? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.coach = coach
        self.summary = summary
        self.image = image
        self.rating = rating
        self.user = user
        self.userID = user?.id ?? UUID()

    }
}
