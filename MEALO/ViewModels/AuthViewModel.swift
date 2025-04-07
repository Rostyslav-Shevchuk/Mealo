//
//  AuthViewModel.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isRegistered = false // Додаємо для відстеження успішної реєстрації
    
    private let authService = AuthService.shared
    
    func register() {
        isLoading = true
        authService.register(email: email, password: password, name: name) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let user):
                    self.errorMessage = nil
                    self.isRegistered = true // Оновлюємо стан
                    self.authService.user = user // Оновлюємо користувача в AuthService
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func login() {
        isLoading = true
        authService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
