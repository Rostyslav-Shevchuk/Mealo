//
//  MealViewModel.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var mealCategories: [MealCategory] = [
        MealCategory(category: "Сніданок", imageName: "breakfast", maxCalories: 900),
        MealCategory(category: "Обід", imageName: "dinner", maxCalories: 1200),
        MealCategory(category: "Вечеря", imageName: "dinnerTwo", maxCalories: 800),
        MealCategory(category: "Перекус", imageName: "snack", maxCalories: 300)
    ]
    
    private let db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    private let mealsKey = "savedMeals"
    private let lastResetDateKey = "lastResetDate"
    
    init() {
        // Завантажуємо збережені дані при ініціалізації
        loadSavedMeals()
        // Перевіряємо, чи потрібно очистити дані
        checkAndResetIfNewDay()
    }
    
    // Завантаження даних за поточний день
    func fetchMeals(for userId: String, completion: @escaping () -> Void = {}) {
        // Перевіряємо, чи настав новий день
        checkAndResetIfNewDay()
        
        // Завантажуємо дані з Firestore лише за поточний день
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        db.collection("meals")
            .whereField("userId", isEqualTo: userId)
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching meals: \(error.localizedDescription)")
                    completion()
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No meals found for today.")
                    self.meals = []
                    self.saveMeals()
                    self.updateMealCategories()
                    completion()
                    return
                }
                
                self.meals = documents.compactMap { doc in
                    try? doc.data(as: Meal.self)
                }
                
                // Оновлюємо локальні дані
                self.saveMeals()
                // Оновлюємо калорії для категорій
                self.updateMealCategories()
                completion()
            }
    }
    
    // Завантаження історії за вибрану дату
    func fetchMealsHistory(for userId: String, on date: Date, completion: @escaping ([Meal]) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        db.collection("meals")
            .whereField("userId", isEqualTo: userId)
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching meal history: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No meals found for the selected date.")
                    completion([])
                    return
                }
                
                let meals = documents.compactMap { doc in
                    try? doc.data(as: Meal.self)
                }
                completion(meals)
            }
    }
    
    // Додавання нової їжі
    func addMeal(_ meal: Meal) {
        do {
            _ = try db.collection("meals").addDocument(from: meal)
            // Додаємо їжу лише якщо вона за поточний день
            let startOfDay = Calendar.current.startOfDay(for: Date())
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            if meal.date >= startOfDay && meal.date < endOfDay {
                self.meals.append(meal)
            }
            self.saveMeals() // Зберігаємо локально
            self.updateMealCategories()
        } catch {
            print("Error adding meal: \(error.localizedDescription)")
        }
    }
    
    // Оновлення калорій для категорій
    private func updateMealCategories() {
        for i in 0..<mealCategories.count {
            let categoryMeals = meals.filter { $0.category == mealCategories[i].category }
            let totalCalories = categoryMeals.reduce(0) { $0 + $1.calories }
            mealCategories[i].totalCalories = totalCalories
        }
    }
    
    // Перевірка, чи настав новий день, і очищення даних
    private func checkAndResetIfNewDay() {
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        
        // Отримуємо дату останнього скидання з UserDefaults
        if let lastResetDate = userDefaults.object(forKey: lastResetDateKey) as? Date {
            // Якщо день змінився, очищаємо дані
            if !Calendar.current.isDate(lastResetDate, inSameDayAs: currentDate) {
                resetData()
                userDefaults.set(startOfDay, forKey: lastResetDateKey)
            }
        } else {
            // Якщо це перший запуск, встановлюємо дату скидання
            userDefaults.set(startOfDay, forKey: lastResetDateKey)
        }
    }
    
    // Очищення даних за поточний день
    private func resetData() {
        meals.removeAll()
        saveMeals() // Оновлюємо локальні дані
        updateMealCategories()
    }
    
    // Збереження даних у UserDefaults
    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            userDefaults.set(encoded, forKey: mealsKey)
        }
    }
    
    // Завантаження даних із UserDefaults
    private func loadSavedMeals() {
        if let savedData = userDefaults.data(forKey: mealsKey),
           let decodedMeals = try? JSONDecoder().decode([Meal].self, from: savedData) {
            self.meals = decodedMeals
            updateMealCategories()
        }
    }
}
