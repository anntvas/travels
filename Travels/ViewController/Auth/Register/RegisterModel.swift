//
//  RegisterModel.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
protocol RegisterModelProtocol {
    func registerUser(username: String, firstName: String, lastName: String, email: String, phone: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class RegisterModel: RegisterModelProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func registerUser(username: String, firstName: String, lastName: String, email: String, phone: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let registerRequest = RegisterRequest(
            username: phone,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: password
        )
        
        networkManager.register(request: registerRequest) { result in
            switch result {
            case .success(let userResponse):
                self.saveUserToCoreData(userResponse)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveUserToCoreData(_ userResponse: UserResponse) {
        let context = DataController.shared.context
        let user = User(context: context)
        user.id = Int64(userResponse.id)
        user.username = userResponse.username
        user.firstName = userResponse.firstName
        user.lastName = userResponse.lastName
        user.phone = userResponse.phone
        user.email = userResponse.email
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения пользователя: \(error)")
        }
    }
}
