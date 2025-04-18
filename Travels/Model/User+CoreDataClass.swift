//
//  User+CoreDataClass.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    // MARK: - Convenience Methods
    
    // Создание нового пользователя
    @discardableResult
    static func create(
        name: String,
        phone: String,
        password: String,
        in context: NSManagedObjectContext
    ) -> User {
        let user = User(context: context)
        user.id = UUID()
        user.name = name
        user.phone = phone
        user.password = password
        
        return user
    }
    
    // Поиск пользователя по телефону
    static func find(byPhone phone: String, in context: NSManagedObjectContext) -> User? {
        // Здесь явно указываем тип запроса
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "phone == %@", phone)
        request.fetchLimit = 1
        
        do {
            // Здесь запрос выполняется с использованием типа NSFetchRequest<User>
            return try context.fetch(request).first
        } catch {
            print("Ошибка поиска пользователя: \(error)")
            return nil
        }
    }


    
    // Проверка пароля
    func checkPassword(_ password: String) -> Bool {
        return self.password == password // В реальном приложении сравнивайте хеши
    }
    
    // Получение всех пользователей (для админки/отладки)
    static func getAll(in context: NSManagedObjectContext) -> [User] {
        // Явно указываем тип запроса
        let request = NSFetchRequest<User>(entityName: "User")

        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка получения пользователей: \(error)")
            return []
        }
    }

    // Удаление пользователя
    static func delete(user: User, in context: NSManagedObjectContext) {
        context.delete(user)
    }
}

