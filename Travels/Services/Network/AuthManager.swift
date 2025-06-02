//
//  AuthManager.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private let tokenKey = "com.travelapp.accessToken"
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    private init() {}
    
    func saveToken(_ token: String) {
        accessToken = token
    }
    
    func clearToken() {
        accessToken = nil
    }
    
    var isLoggedIn: Bool {
        return accessToken != nil
    }
}
