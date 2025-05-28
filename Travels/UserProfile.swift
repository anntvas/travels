//
//  UserProfile.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//

import Foundation
import CoreData

struct UserProfile: Codable {
    let id: String
    let name: String
    let phone: String
    let avatarUrl: String?
    
    // Для локального хранения
    func toCoreDataUser(context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.id = UUID(uuidString: id)
        user.name = name
        user.phone = phone
        
        if let avatarUrl = avatarUrl {
            // Можно добавить загрузку аватара
        }
        
        return user
    }
}
