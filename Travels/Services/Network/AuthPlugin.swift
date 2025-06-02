//
//  AuthPlugin.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation
import Moya
import KeychainSwift

class AuthPlugin: PluginType {
    private let keychain: KeychainSwift
    
    init(keychain: KeychainSwift) {
        self.keychain = keychain
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // Добавляем токен только если это не эндпоинт логина/регистрации
        if !(target.path.contains("login") || target.path.contains("register")),
           let token = keychain.get("accessToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Добавлен токен в заголовки: Bearer \(token)")
        }
        
        return request
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case .failure(let error) = result else { return }
        
        if let response = error.response {
            print("Ошибка сети: \(response.statusCode)")
            if response.statusCode == 403 {
                print("Доступ запрещен. Возможно проблемы с токеном.")
            }
        }
    }
}
