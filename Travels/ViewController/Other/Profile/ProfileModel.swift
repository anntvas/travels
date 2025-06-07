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
    func loadLocalUser(completion: @escaping (Result<UserResponse, Error>) -> Void)
    func loadRemoteUser(completion: @escaping (Result<UserResponse, Error>) -> Void)
    func saveAvatar(image: UIImage)
}

final class ProfileModel: ProfileModelProtocol {
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainSwift()
    private let context = DataController.shared.context

    func loadLocalUser(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])))
            return
        }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(userId))
        do {
            if let user = try context.fetch(request).first {
                let response = UserResponse(
                    id: Int(user.id),
                    username: user.username ?? "",
                    firstName: user.firstName ?? "",
                    lastName: user.lastName ?? "",
                    phone: user.phone ?? "",
                    email: user.email ?? ""
                )
                completion(.success(response))
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func loadRemoteUser(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard keychain.get("accessToken") != nil else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Не авторизован"])))
            return
        }
        networkManager.getUserProfile { result in
            if case let .success(user) = result {
                self.saveToCoreData(user)
            }
            completion(result)
        }
    }

    func saveToCoreData(_ user: UserResponse) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", user.id)
        let userObj = (try? context.fetch(request).first) ?? User(context: context)
        userObj.id = Int64(user.id)
        userObj.firstName = user.firstName
        userObj.lastName = user.lastName
        userObj.phone = user.phone
        userObj.email = user.email
        userObj.username = user.username
        try? context.save()

        // Обновление текущего пользователя
        UserDefaults.standard.set(user.id, forKey: "currentUserId")
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
