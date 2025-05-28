//
//  AuthService.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//

import Foundation
import CoreData
import UIKit

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    var token: String? {
        get { KeychainHelper.shared.read(service: "auth-token", account: "travel-app") }
        set {
            if let newValue = newValue {
                KeychainHelper.shared.save(newValue, service: "auth-token", account: "travel-app")
            } else {
                KeychainHelper.shared.delete(service: "auth-token", account: "travel-app")
            }
        }
    }
    
    var isLoggedIn: Bool {
        return token != nil
    }
    
    func login(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.login(phone: phone, password: password) { result in
            switch result {
            case .success(let response):
                self.token = response.token
                self.saveUserToCoreData(response.user)
                completion(true)
            case .failure(let error):
                print("Login error: \(error)")
                completion(false)
            }
        }
    }
    
    func register(userData: RegistrationData, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.register(userData: userData) { result in
            switch result {
            case .success(let response):
                self.token = response.token
                self.saveUserToCoreData(response.user)
                completion(true)
            case .failure(let error):
                print("Registration error: \(error)")
                completion(false)
            }
        }
    }
    
    func logout() {
        token = nil
        clearCoreDataUser()
        // Переходим на экран авторизации
     //   (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(AuthViewController())
    }
    
    private func saveUserToCoreData(_ profile: UserProfile) {
        let context = DataController.shared.context
        _ = profile.toCoreDataUser(context: context)
        
        do {
            try context.save()
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    private func clearCoreDataUser() {
        let context = DataController.shared.context
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            users.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Failed to delete users: \(error)")
        }
    }
}
