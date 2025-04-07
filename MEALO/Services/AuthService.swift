//
//  AuthService.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    @Published var user: User?
    static let shared = AuthService()
    private init() { checkAuthState() }
    
    private func checkAuthState() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserData(uid: currentUser.uid) { _ in }
        }
    }
    
    func register(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = result?.user.uid else { return }
            let user = User(id: uid, email: email, name: name, height: nil, weight: nil, age: nil, gender: nil, activityLevel: nil, goal: nil, dailyCalories: nil)
            self.saveUserData(user: user) { result in
                switch result {
                case .success:
                    self.user = user
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = result?.user.uid else { return }
            self.fetchUserData(uid: uid, completion: completion)
        }
    }
    
    public func saveUserData(user: User, completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        do {
            try Firestore.firestore().collection("users").document(user.id).setData(from: user) { error in
                if let error = error {
                    print("Failed to save user data: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Successfully saved user data for \(user.id)")
                    self.user = user
                    completion(.success(()))
                }
            }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    private func fetchUserData(uid: String, completion: @escaping (Result<User, Error>) -> Void = { _ in }) {
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = snapshot?.data(),
                  let user = try? Firestore.Decoder().decode(User.self, from: data) else { return }
            self.user = user // Оновлюємо локального користувача
            completion(.success(user))
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        user = nil
    }
}
