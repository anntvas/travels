//
//  ProfileModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import CoreData
import KeychainSwift
import UIKit

protocol ProfileModelProtocol {
    func loadUser(completion: @escaping (Result<UserResponse, Error>) -> Void)
    func saveAvatar(image: UIImage)
    func loadAvatar(completion: @escaping (UIImage?) -> Void) // Добавляем
}

final class ProfileModel: ProfileModelProtocol {
    func loadAvatar(completion: @escaping (UIImage?) -> Void) {
    
    }
    
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainSwift()
    private let context = DataController.shared.context
    
    func loadUser(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard keychain.get("accessToken") != nil else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Не авторизован"])))
            return
        }
        
        networkManager.getUserProfile { [weak self] result in
            switch result {
            case .success(let user):
                // Сохраняем только ID пользователя для аватара
                UserDefaults.standard.set(user.id, forKey: "currentUserId")
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveAvatar(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else { return }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(userId))
        if let user = try? context.fetch(request).first {
            user.avatarData = data
            try? context.save()
        }
    }
}
