//
//  CoachModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 9/1/26.
//

import Foundation

struct Coach: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let specialty: String
    let bio: String
    let imageSystemName: String

    init(id: String, name: String, specialty: String, bio: String, imageSystemName: String = "person.crop.circle.fill") {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.bio = bio
        self.imageSystemName = imageSystemName
    }
}

extension Coach {
    static let sampleCoaches: [Coach] = [
        Coach(id: "jim-carter",
              name: "Jim Carter",
              specialty: "Strength & Conditioning",
              bio: "Specializes in powerlifting fundamentals and progressive overload.",
              imageSystemName: "figure.strengthtraining.traditional"),
        Coach(id: "maria-alvarez",
              name: "Maria Alvarez",
              specialty: "HIIT & Cardio",
              bio: "Builds high-intensity interval programs for fat loss and endurance.",
              imageSystemName: "figure.run"),
        Coach(id: "david-kim",
              name: "David Kim",
              specialty: "Mobility & Recovery",
              bio: "Focuses on flexibility, injury prevention, and recovery.",
              imageSystemName: "figure.flexibility"),
        Coach(id: "sara-thompson",
              name: "Sara Thompson",
              specialty: "Nutrition Coaching",
              bio: "Pairs training programs with sustainable nutrition habits.",
              imageSystemName: "leaf.fill")
    ]
}
