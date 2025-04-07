//
//  MealCategory.swift
//  MEALO
//
//  Created by Ростислав on 02.04.2025.
//

import Foundation

// Модель для категорії їжі
struct MealCategory: Identifiable {
    let id = UUID()
    let category: String
    let imageName: String
    let maxCalories: Int
    var totalCalories: Double = 0
}
