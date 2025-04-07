//
//  ContentView.swift
//  MEALO
//
//  Created by Ростислав on 17.03.2025.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authService = AuthService.shared
    
    var body: some View {
        TabView {
            CalorieTrackerView()
                .tabItem {
                    Image(systemName: "fuelpump.fill")
                    Text("Прийоми їжі")
                }
            
            WorkoutscheduleView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Графік тренувань")
                }
            
            RecipesView()
                .tabItem {
                    Image(systemName: "frying.pan")
                    Text("Рецепти")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профіль")
                }
        }
        .accentColor(.green) // Колір активної вкладки
    }
}

#Preview {
    MainTabView()
}
