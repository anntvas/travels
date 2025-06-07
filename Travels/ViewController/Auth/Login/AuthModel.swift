//
//  AuthModel.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import KeychainSwift
import CoreData
protocol AuthModelProtocol {
    func login(phone: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthModel: AuthModelProtocol {
    private let keychain = KeychainSwift()
    private let networkManager: NetworkManagerProtocol
    private let dataController: DataController
    
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        dataController: DataController = DataController.shared
    ) {
        self.networkManager = networkManager
        self.dataController = dataController
    }
    
    func login(phone: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let loginRequest = LoginRequest(username: phone, password: password)
        
        networkManager.login(request: loginRequest) { [weak self] result in
            switch result {
            case .success(let tokenResponse):
                // Сохраняем токены
                self?.keychain.set(tokenResponse.accessToken, forKey: "accessToken")
                self?.keychain.set(tokenResponse.refreshToken, forKey: "refreshToken")
                
                // Получаем профиль пользователя
                self?.fetchUserProfile(completion: completion)
                
            case .failure:
                // Пробуем локальную авторизацию
                self?.fallbackToLocalAuth(phone: phone, password: password, completion: completion)
            }
        }
    }
    
    private func fetchUserProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        networkManager.getUserProfile { [weak self] result in
            switch result {
            case .success(let userResponse):
                self?.saveUser(userResponse)
                completion(.success(()))
                
            case .failure(let error as NSError) where error.code == 403:
                self?.handleTokenExpiration(completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleTokenExpiration(completion: @escaping (Result<Void, Error>) -> Void) {
        networkManager.refreshToken { [weak self] result in
            switch result {
            case .success(let tokenResponse):
                // Сохраняем новые токены
                self?.keychain.set(tokenResponse.accessToken, forKey: "accessToken")
                self?.keychain.set(tokenResponse.refreshToken, forKey: "refreshToken")
                // Повторяем запрос профиля
                self?.fetchUserProfile(completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fallbackToLocalAuth(
        phone: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let context = dataController.context
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "phone == %@ AND password == %@", phone, password)
        
        do {
            let users = try context.fetch(request)
            if users.first != nil {
                completion(.success(()))
            } else {
                completion(.failure(AuthError.invalidCredentials))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func saveUser(_ userResponse: UserResponse) {
        let context = dataController.context
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(userResponse.id))
        
        let user: User
        if let existingUser = try? context.fetch(request).first {
            user = existingUser
        } else {
            user = User(context: context)
            user.id = Int64(userResponse.id)
        }
        
        user.username = userResponse.username
        user.firstName = userResponse.firstName
        user.lastName = userResponse.lastName
        user.phone = userResponse.phone
        user.email = userResponse.email
        
        do {
            try context.save()
            UserDefaults.standard.set(user.id, forKey: "currentUserId")
        } catch {
            print("Ошибка сохранения пользователя: \(error)")
        }
    }
}

enum AuthError: Error {
    case invalidCredentials
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Неверный телефон или пароль"
        }
    }
}
