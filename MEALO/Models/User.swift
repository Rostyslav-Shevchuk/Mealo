//
//  User.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String
    var height: Double? // Зріст у см
    var weight: Double? // Вага у кг
    var age: Int? // Вік
    var gender: Gender? // Стать
    var activityLevel: ActivityLevel? // Рівень активності
    var goal: Goal? // Ціль
    var dailyCalories: Int? // Розрахована норма калорій
}

enum Gender: String, Codable, CaseIterable {
    case male = "Чоловік"
    case female = "Жінка"
}

enum ActivityLevel: String, Codable, CaseIterable {
    case sedentary = "Сидячий"
    case light = "Легка активність"
    case moderate = "Помірна активність"
    case active = "Висока активність"
}

enum Goal: String, Codable, CaseIterable {
    case lose = "Скинути вагу"
    case maintain = "Підтримувати вагу"
    case gain = "Набрати вагу"
}
