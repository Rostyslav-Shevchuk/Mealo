//
//  MealHistoryView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct MealHistoryView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = MealViewModel()
    @State private var selectedDate = Date()
    @State private var mealsForSelectedDate: [Meal] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                // Вибір дати
                DatePicker("Виберіть дату",
                           selection: $selectedDate,
                           displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .padding()
                    .onChange(of: selectedDate) { _ in
                        fetchMealsForSelectedDate()
                    }
                
                // Список їжі за вибрану дату
                if mealsForSelectedDate.isEmpty {
                    Text("Немає даних за вибрану дату")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(mealsForSelectedDate) { meal in
                            VStack(alignment: .leading) {
                                Text(meal.name)
                                    .font(.headline)
                                Text("Категорія: \(meal.category)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Калорії: \(Int(meal.calories))")
                                Text("Білки: \(Int(meal.protein)) г")
                                Text("Жири: \(Int(meal.fat)) г")
                                Text("Вуглеводи: \(Int(meal.carbs)) г")
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Історія прийомів їжі")
            .onAppear {
                fetchMealsForSelectedDate()
            }
        }
    }
    
    // Завантаження їжі за вибрану дату
    private func fetchMealsForSelectedDate() {
        guard let userId = authService.user?.id else {
            mealsForSelectedDate = []
            return
        }
        
        viewModel.fetchMealsHistory(for: userId, on: selectedDate) { meals in
            self.mealsForSelectedDate = meals
        }
    }
}

#Preview {
    MealHistoryView()
        .environmentObject(AuthService.shared)
}
