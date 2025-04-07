//
//  OnboardingView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject var authService: AuthService
    
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var gender: Gender?
    @State private var activityLevel: ActivityLevel?
    @State private var goal: Goal?
    @State private var isSaving = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            TabView(selection: $currentPage) {
                // Екран 1: Вітання
                VStack(spacing: 20) {
                    Text("Ласкаво просимо до Mealo!")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                    Text("Твій помічник у здоровому харчуванні та тренуваннях")
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .multilineTextAlignment(.center)
                    Button("Далі") {
                        currentPage += 1
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                }
                .padding()
                .tag(0)
                
                // Екран 2: Особисті дані
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Розкажи про себе")
                            .font(.system(size: 25, weight: .bold, design: .monospaced))
                        
                        HStack(spacing: 10) {
                            Image(systemName: "ruler")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                            TextField("Зріст (см)", text: $height)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .regular, design: .monospaced))
                                .onChange(of: height) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        height = filtered
                                    }
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 0, y: 8)
                        .frame(width: 300, height: 50)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "scalemass")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                            TextField("Вага (кг)", text: $weight)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .regular, design: .monospaced))
                                .onChange(of: weight) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        weight = filtered
                                    }
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 0, y: 8)
                        .frame(width: 300, height: 50)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                            TextField("Вік", text: $age)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .regular, design: .monospaced))
                                .onChange(of: age) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        age = filtered
                                    }
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 0, y: 8)
                        .frame(width: 300, height: 50)
                        
                        Picker("Стать", selection: $gender) {
                            Text("Вибери").tag(Gender?.none)
                            ForEach(Gender.allCases, id: \.self) { g in
                                Text(g.rawValue).tag(Gender?.some(g))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 300)
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.system(size: 15))
                        }
                        
                        Button("Далі") {
                            currentPage += 1
                        }
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.yellow]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .disabled(height.isEmpty || weight.isEmpty || age.isEmpty || gender == nil)
                    }
                    .padding()
                }
                .ignoresSafeArea(.keyboard)
                .toolbar { // Додаємо кнопку для приховування клавіатури
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Готово") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
                .tag(1)
                
                // Екран 3: Активність
                VStack(spacing: 20) {
                    Text("Твій рівень активності")
                        .font(.system(size: 25, weight: .bold, design: .monospaced))
                    
                    Picker("Активність", selection: $activityLevel) {
                        Text("Вибери").tag(ActivityLevel?.none)
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(ActivityLevel?.some(level))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                    .frame(width: 300)
                    
                    Button("Далі") {
                        currentPage += 1
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .disabled(activityLevel == nil)
                }
                .padding()
                .tag(2)
                
                // Екран 4: Ціль
                VStack(spacing: 20) {
                    Text("Яка твоя ціль?")
                        .font(.system(size: 25, weight: .bold, design: .monospaced))
                    
                    Picker("Ціль", selection: $goal) {
                        Text("Вибери").tag(Goal?.none)
                        ForEach(Goal.allCases, id: \.self) { g in
                            Text(g.rawValue).tag(Goal?.some(g))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                    .frame(width: 300)
                    
                    Button("Далі") {
                        currentPage += 1
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .disabled(goal == nil)
                }
                .padding()
                .tag(3)
                
                // Екран 5: Завершення
                VStack(spacing: 20) {
                    Text("Готово!")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                    Text("Твій профіль налаштовано")
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                    
                    Button(action: {
                        saveProfile()
                    }) {
                        Text("Почати")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.yellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    .disabled(isSaving)
                }
                .padding()
                .tag(4)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
    
    private func saveProfile() {
        guard let heightValue = Double(height), !heightValue.isNaN, heightValue > 0 else {
            errorMessage = "Будь ласка, введіть коректний зріст (наприклад, 170.5)"
            return
        }
        guard let weightValue = Double(weight), !weightValue.isNaN, weightValue > 0 else {
            errorMessage = "Будь ласка, введіть коректну вагу (наприклад, 70.5)"
            return
        }
        guard let ageValue = Int(age), ageValue > 0 else {
            errorMessage = "Будь ласка, введіть коректний вік (наприклад, 25)"
            return
        }
        guard let user = authService.user,
              let genderValue = gender,
              let activity = activityLevel,
              let goalValue = goal else {
            errorMessage = "Будь ласка, заповніть усі поля"
            return
        }
        
        errorMessage = nil
        isSaving = true
        let updatedUser = User(
            id: user.id,
            email: user.email,
            name: user.name,
            height: heightValue,
            weight: weightValue,
            age: ageValue,
            gender: genderValue,
            activityLevel: activity,
            goal: goalValue,
            dailyCalories: calculateDailyCalories(height: heightValue, weight: weightValue, age: ageValue, gender: genderValue, activity: activity, goal: goalValue)
        )
        
        authService.saveUserData(user: updatedUser) { result in
            DispatchQueue.main.async {
                self.isSaving = false
                switch result {
                case .success:
                    self.authService.user = updatedUser
                    print("Profile saved!")
                case .failure(let error):
                    self.errorMessage = "Помилка збереження: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func calculateDailyCalories(height: Double, weight: Double, age: Int, gender: Gender, activity: ActivityLevel, goal: Goal) -> Int {
        let bmr = gender == .male ?
            (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5 :
            (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
        
        let activityMultiplier: Double
        switch activity {
        case .sedentary: activityMultiplier = 1.2
        case .light: activityMultiplier = 1.375
        case .moderate: activityMultiplier = 1.55
        case .active: activityMultiplier = 1.725
        }
        
        let goalAdjustment: Double
        switch goal {
        case .lose: goalAdjustment = -500
        case .maintain: goalAdjustment = 0
        case .gain: goalAdjustment = 500
        }
        
        let result = (bmr * activityMultiplier) + goalAdjustment
        return Int(result.isNaN ? 0 : result)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthService.shared)
}
