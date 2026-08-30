//
//  Api.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import Foundation

struct ApiWorkouts {
    static func defaultRoutines(for user: User) -> [Routine] {
        return [
            Routine(
                title: "Push",
                coach: "Jim",
                summary: "Lorem ipsum dolor sit amet, consectetur ascing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                image: "push",
                user: user
            ),
            Routine(
                title: "Lower",
                coach: "Jim",
                summary: "Lorem ipsum dolor sit amet, consectetur ascing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                image: "legs",
                user: user
            ),
            Routine(
                title: "Pull",
                coach: "Jim",
                summary: "Lorem ipsum dolor sit amet, consectetur ascing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure  pariatur.",
                image: "pull",
                user: user
            )
        ]
    }
}

