//
//  LoginView.swift
//  MEALO
//
//  Created by Ростислав on 17.03.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Text("Привіт")
                    .font(.system(size: 64, weight: .bold, design: .monospaced))
                
                Text("Увійди у свій акаунт")
                    .font(.system(size: 18, weight: .regular, design: .monospaced))
                
                HStack(spacing: 10) {
                    Image("email")
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.gray)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(40)
                .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 0, y: 8)
                .frame(width: 300, height: 50)
                
                HStack(spacing: 10) {
                    Image("password")
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                    SecureField("Пароль", text: $viewModel.password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.gray)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(40)
                .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 0, y: 8)
                .frame(width: 300, height: 50)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                }
                
                HStack(spacing: 10){
                    Text("Увійти")
                        .font(.system(size: 25, weight: .bold, design: .monospaced))
                    
                    Button(action: {
                        viewModel.login()
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 100, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .disabled(viewModel.isLoading)
                }
                
                NavigationLink {
                    RegisterView()
                } label: {
                    HStack {
                        Text("Немаєте акаунта?")
                            .foregroundColor(Color.black)
                        Text("Створити")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .underline(true)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
}
