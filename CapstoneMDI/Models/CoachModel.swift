//
//  CoachModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 9/1/26.
//

import Foundation
import SwiftData

@Model
final class Coach: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var specialty: String
    var bio: String
    var imageSystemName: String
    var savedRating: Int?

    init(name: String, specialty: String, bio: String, imageSystemName: String = "person.crop.circle.fill", savedRating: Int? = nil) {
        self.name = name
        self.specialty = specialty
        self.bio = bio
        self.imageSystemName = imageSystemName
        self.savedRating = savedRating
    }
}

extension Coach {
    static let sampleCoaches: [Coach] = [
        Coach(name: "Jim Carter",
              specialty: "Strength & Conditioning",
              bio: "Specializes in powerlifting fundamentals and progressive overload.",
              imageSystemName: "figure.strengthtraining.traditional"),
        Coach(name: "Maria Alvarez",
              specialty: "HIIT & Cardio",
              bio: "Builds high-intensity interval programs for fat loss and endurance.",
              imageSystemName: "figure.run"),
        Coach(name: "David Kim",
              specialty: "Mobility & Recovery",
              bio: "Focuses on flexibility, injury prevention, and recovery.",
              imageSystemName: "figure.flexibility"),
        Coach(name: "Sara Thompson",
              specialty: "Nutrition Coaching",
              bio: "Pairs training programs with sustainable nutrition habits.",
              imageSystemName: "leaf.fill")
    ]
}
