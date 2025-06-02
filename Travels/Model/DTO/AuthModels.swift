//
//  AuthModels.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//

import Foundation

// MARK: - Модели для запросов
struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let password: String
    let phone: String
    let firstName: String
    let lastName: String
    let email: String
}

// MARK: - Модели для ответов
struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let refreshExpiresIn: Int
    let tokenType: String
}

struct UserResponse: Codable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
}

struct ErrorResponse: Codable {
    let status: Int
    let message: String
}
