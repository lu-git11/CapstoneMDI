//
//  ExerciseSearchModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/18/26.
//

import Foundation
 
struct ExerciseInfoListResponse: Decodable {
    let count: Int
    let next: String?
    let results: [ExerciseInfo]
}
 
struct ExerciseInfo: Decodable, Identifiable {
    let id: Int
    let category: ExerciseCategoryInfo?
    let translations: [ExerciseTranslation]
    
    // prefer the English translation (language id 2), fall back to whatever's first
    var displayName: String {
        let english = translations.first(where: { $0.language == 2 })
        return english?.name ?? translations.first?.name ?? "Unnamed exercise"
    }
}
 
struct ExerciseCategoryInfo: Decodable {
    let name: String?
}
 
struct ExerciseTranslation: Decodable {
    let language: Int
    let name: String
}
