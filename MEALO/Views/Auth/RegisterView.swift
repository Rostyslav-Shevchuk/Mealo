import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
                VStack(spacing: 150) {
                    
                    VStack(spacing: 50){
                        Text("Створити акаунт")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                        
                        VStack(spacing: 40){
                            // Input Name
                            HStack(spacing: 10) {
                                Image("profile")
                                    .foregroundColor(.gray)
                                    .frame(width: 24, height: 24)
                                TextField("Ім'я", text: $viewModel.name)
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
                            
                            //Input Email
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
                                    .keyboardType(.emailAddress) // Додаємо для кращої роботи клавіатури
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(40)
                            .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 0, y: 8)
                            .frame(width: 300, height: 50)
                            
                            //Input Password
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
                        }
                    }
                    
                    HStack(spacing: 5){
                        Text("Створити")
                            .font(.system(size: 25, weight: .bold, design: .monospaced))
                        
                        Button(action: {
                            viewModel.register()
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
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
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
        }
    
}

#Preview {
    RegisterView()
        .environmentObject(AuthService.shared)
}
