//
//  Meal.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import Foundation

struct Meal: Identifiable, Codable, Equatable {
    let id: String
    let category: String
    let name: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let userId: String
    let date: Date
}
