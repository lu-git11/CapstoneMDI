//
//  Api.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

func getWorkout() -> [Workout] {
    return [
        Workout(
            title: "Push",
            coach: "Jim",
            summary: "Lorem ipsum dolor sit amet, consectetur ascing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure  pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            image: "push"
        ),
        Workout(
            title: "Lower",
            coach: "Jim",
            summary: "Lorem ipsum dolor sit amet, consectetur ascing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure  pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            image: "legs"
        ),
        Workout(
            title: "Pull",
            coach: "Jim",
            summary: "Lorem ipsum dolor sit amet, consectetur ascing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure  pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            image: "pull"
        )
    ]
}
