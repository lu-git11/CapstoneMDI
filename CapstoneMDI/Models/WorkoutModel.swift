//
//  WorkoutModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import Foundation
import Combine

struct Workout: Identifiable {
    let id: UUID = UUID()
    var title: String
    var coach: String
    var summary: String
    var image: String
    
    var reviewTitle: String = ""
    var reviewText: String = ""
    var rating: Int? = nil
}
