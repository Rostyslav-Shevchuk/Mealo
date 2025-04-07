//
//  ProfileSetupView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authService = AuthService.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Профіль \(authService.user?.name ?? "")")
                .font(.system(size: 25, weight: .bold, design: .monospaced))
            
            if let user = authService.user {
                Text("Зріст: \(user.height ?? 0, specifier: "%.0f") см")
                Text("Вага: \(user.weight ?? 0, specifier: "%.0f") кг")
                Text("Вік: \(user.age ?? 0)")
                Text("Стать: \(user.gender?.rawValue ?? "Не вказано")")
                Text("Активність: \(user.activityLevel?.rawValue ?? "Не вказано")")
                Text("Ціль: \(user.goal?.rawValue ?? "Не вказано")")
                Text("Калорії: \(user.dailyCalories ?? 0)")
            }
            
            Button("Вийти") {
                authService.signOut()
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
    }
}

#Preview {
    ProfileView()
}
