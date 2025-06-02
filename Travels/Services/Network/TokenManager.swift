//
//  TokenManager.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation
import KeychainSwift

class TokenManager {
    static let shared = TokenManager()
    private let keychain = KeychainSwift()
    
    var accessToken: String? {
        return keychain.get("accessToken")
    }
    
    var refreshToken: String? {
        return keychain.get("refreshToken")
    }
    
    var isAccessTokenValid: Bool {
        guard let expiration = UserDefaults.standard.object(forKey: "accessTokenExpiration") as? Date else {
            return false
        }
        return expiration > Date()
    }
    
    var isRefreshTokenValid: Bool {
        guard let expiration = UserDefaults.standard.object(forKey: "refreshTokenExpiration") as? Date else {
            return false
        }
        return expiration > Date()
    }
    
    func saveTokens(response: TokenResponse) {
        keychain.set(response.accessToken, forKey: "accessToken")
        keychain.set(response.refreshToken, forKey: "refreshToken")
        
        UserDefaults.standard.set(
            Date().addingTimeInterval(TimeInterval(response.expiresIn)),
            forKey: "accessTokenExpiration"
        )
        UserDefaults.standard.set(
            Date().addingTimeInterval(TimeInterval(response.refreshExpiresIn)),
            forKey: "refreshTokenExpiration"
        )
    }
    
    func clearTokens() {
        keychain.delete("accessToken")
        keychain.delete("refreshToken")
        UserDefaults.standard.removeObject(forKey: "accessTokenExpiration")
        UserDefaults.standard.removeObject(forKey: "refreshTokenExpiration")
    }
}
