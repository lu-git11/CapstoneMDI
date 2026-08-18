//
//  ReviewModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/18/26.
//

import Foundation
import Combine

struct Review: Codable {
    
    var reviewTitle: String = ""
    var reviewText: String = ""
    var rating: Int? = nil
}
