//
//  CalorieTrackerView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI
import HealthKit
import FirebaseFirestore

struct CalorieTrackerView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var mealViewModel = MealViewModel()
    
    // Прогрес калорій
    @State private var consumedCalories: CGFloat = 0
    @State private var remainingCalories: CGFloat = 0
    @State private var burnedCalories: CGFloat = 0
    @State private var proteinConsumed: CGFloat = 0
    @State private var fatConsumed: CGFloat = 0
    @State private var carbsConsumed: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    // Змінні для анімації
    @State private var animatedProgress: CGFloat = 0
    @State private var animatedProtein: CGFloat = 0
    @State private var animatedFat: CGFloat = 0
    @State private var animatedCarbs: CGFloat = 0
    @State private var isVisible: Bool = false
    @State private var isDataLoaded: Bool = false
    
    private var maxCalories: CGFloat {
        CGFloat(authService.user?.dailyCalories ?? 2000)
    }
    private let maxProtein: CGFloat = 150
    private let maxFat: CGFloat = 70
    private let maxCarbs: CGFloat = 300
    
    // Дані HealthKit
    @State private var stepCount: Int = 0
    @State private var floorCount: Int = 0
    @State private var healthKitError: String? = nil
    private let healthStore = HKHealthStore()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Кнопка для переходу до історії
                NavigationLink(destination: MealHistoryView()) {
                    Text("Переглянути історію")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .opacity(isVisible ? 1 : 0)
                
                // Круговой прогрес-бар із фоном
                VStack(spacing: 15) {
                    CalorieProgressBarView(
                        consumedCalories: consumedCalories,
                        remainingCalories: remainingCalories,
                        burnedCalories: burnedCalories,
                        progress: animatedProgress
                    )
                    
                    HStack(spacing: 15) {
                        ProgressBarView(
                            title: "Білки",
                            value: animatedProtein,
                            maxValue: maxProtein
                        )
                        ProgressBarView(
                            title: "Жири",
                            value: animatedFat,
                            maxValue: maxFat
                        )
                        ProgressBarView(
                            title: "Вуглеводи",
                            value: animatedCarbs,
                            maxValue: maxCarbs
                        )
                    }
                }
                .padding()
                .background(Color(red: 0.2, green: 0.8, blue: 0.6))
                .cornerRadius(15)
                .opacity(isVisible ? 1 : 0)
                
                // Список категорій (Сніданок, Обід, Вечеря, Перекус)
                List {
                    ForEach(mealViewModel.mealCategories, id: \.category) { mealCategory in
                        NavigationLink(destination: MealDetailView(meal: mealCategory.category, viewModel: mealViewModel)) {
                            HStack {
                                Image(mealCategory.imageName)
                                    .foregroundColor(.black)
                                Text(mealCategory.category)
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(Int(mealCategory.totalCalories))/\(mealCategory.maxCalories)")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .frame(height: 200)
                .opacity(isVisible ? 1 : 0)
                
                // Картки "ШОДЕННІ КРОКИ" та "Пройдено поверхів"
                if let error = healthKitError {
                    Text("Помилка HealthKit: \(error)")
                        .foregroundColor(.red)
                        .padding()
                        .opacity(isVisible ? 1 : 0)
                } else {
                    HStack(spacing: 25.0) {
                        // Картка "ШОДЕННІ КРОКИ"
                        VStack(alignment: .leading) {
                            HStack {
                                Text("ШОДЕННІ КРОКИ")
                                    .font(.system(size: 16, weight: .bold))
                                Spacer()
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 24))
                            }
                            Text("Ціль: 10 000")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(stepCount, specifier: "%.0f")")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        
                        // Картка "Пройдено поверхів"
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Пройдено поверхів")
                                    .font(.system(size: 16, weight: .bold))
                                Spacer()
                                Image(systemName: "figure.stairs")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 24))
                            }
                            Text("Ціль: 10")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(floorCount, specifier: "%.0f")")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                }
            }
            .navigationTitle("Прийоми їжі")
            .onAppear {
                // Спочатку робимо компоненти невидимими
                isVisible = false
                isDataLoaded = false
                
                // Завантажуємо дані
                requestHealthKitAuthorization()
                fetchStepCount()
                fetchFloorCount()
                fetchBurnedCalories()
                
                // Завантажуємо дані з Firestore
                mealViewModel.fetchMeals(for: authService.user?.id ?? "") {
                    // Оновлюємо калорії після завантаження даних
                    updateCalories()
                    isDataLoaded = true
                    
                    // Показуємо компоненти з анімацією появи
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isVisible = true
                        }
                        
                        // Анімація прогрес-барів
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                animatedProgress = progress
                                animatedProtein = proteinConsumed
                                animatedFat = fatConsumed
                                animatedCarbs = carbsConsumed
                            }
                        }
                    }
                }
            }
            .onChange(of: mealViewModel.meals) { _ in
                updateCalories()
                // Оновлюємо анімацію при зміні даних
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedProgress = progress
                    animatedProtein = proteinConsumed
                    animatedFat = fatConsumed
                    animatedCarbs = carbsConsumed
                }
            }
        }
    }
    
    // Обчислювана властивість для нормалізації прогресу
    private var normalizedProgress: CGFloat {
        min(consumedCalories / maxCalories, 1.0)
    }
    
    // Оновлення калорій
    private func updateCalories() {
        consumedCalories = mealViewModel.meals.reduce(0) { $0 + $1.calories }
        proteinConsumed = mealViewModel.meals.reduce(0) { $0 + $1.protein }
        fatConsumed = mealViewModel.meals.reduce(0) { $0 + $1.fat }
        carbsConsumed = mealViewModel.meals.reduce(0) { $0 + $1.carbs }
        
        remainingCalories = max(0, maxCalories - consumedCalories) // Залишилось не може бути від’ємним
        progress = normalizedProgress
    }
    
    // Запит на авторизацію HealthKit
    private func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            healthKitError = "HealthKit недоступний на цьому пристрої."
            return
        }
        
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let floorType = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
        let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [stepType, floorType, calorieType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("HealthKit authorization granted.")
                    self.healthKitError = nil
                } else if let error = error {
                    self.healthKitError = "Помилка авторизації HealthKit: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Отримання кількості кроків за день
    private func fetchStepCount() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            healthKitError = "Тип даних для кроків недоступний."
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.healthKitError = "Помилка отримання кроків: \(error.localizedDescription)"
                    return
                }
                
                guard let result = result, let sum = result.sumQuantity() else {
                    self.healthKitError = "Дані про кроки недоступні."
                    return
                }
                
                let steps = sum.doubleValue(for: HKUnit.count())
                self.stepCount = Int(steps)
            }
        }
        
        healthStore.execute(query)
    }
    
    // Отримання кількості поверхів за день
    private func fetchFloorCount() {
        guard let floorType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) else {
            healthKitError = "Тип даних для поверхів недоступний."
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: floorType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.healthKitError = "Помилка отримання поверхів: \(error.localizedDescription)"
                    return
                }
                
                guard let result = result, let sum = result.sumQuantity() else {
                    self.healthKitError = "Дані про поверхи недоступні."
                    return
                }
                
                let floors = sum.doubleValue(for: HKUnit.count())
                self.floorCount = Int(floors)
            }
        }
        
        healthStore.execute(query)
    }
    
    // Отримання спалених калорій за день
    private func fetchBurnedCalories() {
        guard let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            healthKitError = "Тип даних для спалених калорій недоступний."
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: calorieType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.healthKitError = "Помилка отримання спалених калорій: \(error.localizedDescription)"
                    return
                }
                
                guard let result = result, let sum = result.sumQuantity() else {
                    self.healthKitError = "Дані про спалені калорії недоступні."
                    return
                }
                
                let calories = sum.doubleValue(for: HKUnit.kilocalorie())
                self.burnedCalories = CGFloat(calories)
            }
        }
        
        healthStore.execute(query)
    }
}

#Preview {
    CalorieTrackerView()
        .environmentObject(AuthService.shared)
}
