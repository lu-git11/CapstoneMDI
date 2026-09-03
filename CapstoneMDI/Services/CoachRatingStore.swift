//
//  CoachRatingStore.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 9/1/26.
//

import Foundation

enum CoachRatingStorage {
    private static let key = "coachRatings"

    static func rating(for coach: Coach) -> Int? {
        let all = UserDefaults.standard.dictionary(forKey: key) as? [String: Int] ?? [:]
        return all[coach.id]
    }

    static func save(_ rating: Int, for coach: Coach) {
        var all = UserDefaults.standard.dictionary(forKey: key) as? [String: Int] ?? [:]
        all[coach.id] = rating
        UserDefaults.standard.set(all, forKey: key)
    }
}
