//
//  AuthModels.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    let user: UserProfile
}

struct RegistrationData: Codable {
    let name: String
    let phone: String
    let password: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "phone": phone,
            "password": password
        ]
    }
}

struct ErrorResponse: Codable {
    let message: String
}
