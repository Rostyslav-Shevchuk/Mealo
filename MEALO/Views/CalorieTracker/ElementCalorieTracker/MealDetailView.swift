//
//  MealDetailView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct MealDetailView: View {
    let meal: String
    @ObservedObject var viewModel: MealViewModel
    
    @State private var mealName: String = ""
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var fat: String = ""
    @State private var carbs: String = ""
    
    // Обчислювана властивість для повідомлення про помилку
    private var errorMessage: String? {
        if mealName.isEmpty {
            return "Назва їжі не може бути порожньою."
        }
        
        if let caloriesValue = Double(calories), caloriesValue < 0 {
            return "Калорії мають бути числом і не від’ємними."
        } else if Double(calories) == nil && !calories.isEmpty {
            return "Калорії мають бути числом."
        }
        
        if let proteinValue = Double(protein), proteinValue < 0 {
            return "Білки мають бути числом і не від’ємними."
        } else if Double(protein) == nil && !protein.isEmpty {
            return "Білки мають бути числом."
        }
        
        if let fatValue = Double(fat), fatValue < 0 {
            return "Жири мають бути числом і не від’ємними."
        } else if Double(fat) == nil && !fat.isEmpty {
            return "Жири мають бути числом."
        }
        
        if let carbsValue = Double(carbs), carbsValue < 0 {
            return "Вуглеводи мають бути числом і не від’ємними."
        } else if Double(carbs) == nil && !carbs.isEmpty {
            return "Вуглеводи мають бути числом."
        }
        
        return nil
    }
    
    // Обчислювана властивість для перевірки валідації
    private var isFormValid: Bool {
        guard !mealName.isEmpty else { return false }
        guard let caloriesValue = Double(calories), caloriesValue >= 0 else { return false }
        guard let proteinValue = Double(protein), proteinValue >= 0 else { return false }
        guard let fatValue = Double(fat), fatValue >= 0 else { return false }
        guard let carbsValue = Double(carbs), carbsValue >= 0 else { return false }
        return true
    }
    
    var body: some View {
        Form {
            Section(header: Text("Додати їжу")) {
                TextField("Назва їжі", text: $mealName)
                TextField("Калорії", text: $calories)
                    .keyboardType(.numberPad)
                TextField("Білки (г)", text: $protein)
                    .keyboardType(.numberPad)
                TextField("Жири (г)", text: $fat)
                    .keyboardType(.numberPad)
                TextField("Вуглеводи (г)", text: $carbs)
                    .keyboardType(.numberPad)
                
                // Показуємо повідомлення про помилку, якщо воно є
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button("Додати") {
                    // Додаємо їжу, якщо форма валідна
                    if isFormValid {
                        let newMeal = Meal(
                            id: UUID().uuidString,
                            category: meal,
                            name: mealName,
                            calories: Double(calories)!,
                            protein: Double(protein)!,
                            fat: Double(fat)!,
                            carbs: Double(carbs)!,
                            userId: AuthService.shared.user?.id ?? "",
                            date: Date()
                        )
                        viewModel.addMeal(newMeal)
                        
                        // Очищаємо поля
                        mealName = ""
                        calories = ""
                        protein = ""
                        fat = ""
                        carbs = ""
                    }
                }
                .disabled(!isFormValid) // Блокуємо кнопку, якщо форма не валідна
            }
            
            Section(header: Text("Список їжі")) {
                ForEach(viewModel.meals.filter { $0.category == meal }) { meal in
                    VStack(alignment: .leading) {
                        Text(meal.name)
                            .font(.headline)
                        Text("Калорії: \(Int(meal.calories))")
                        Text("Білки: \(Int(meal.protein)) г")
                        Text("Жири: \(Int(meal.fat)) г")
                        Text("Вуглеводи: \(Int(meal.carbs)) г")
                    }
                }
            }
        }
        .navigationTitle(meal)
    }
}

#Preview {
    MealDetailView(meal: "Сніданок", viewModel: MealViewModel())
        .environmentObject(AuthService.shared)
}
