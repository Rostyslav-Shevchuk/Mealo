//
//  MEALOApp.swift
//  MEALO
//
//  Created by Ростислав on 17.03.2025.
//

import SwiftUI
import FirebaseCore

@main
struct MealoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Додаємо делегат
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthService.shared)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.user == nil {
            LoginView()
        } else if authService.user?.height == nil {
            OnboardingView()
        } else {
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService.shared)
}
