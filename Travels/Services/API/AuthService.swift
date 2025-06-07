//
//  AuthService.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Moya
import Foundation

enum AuthService {
    case login(request: LoginRequest)
    case register(request: RegisterRequest)
    case getUserProfile
    case getUserId
    case refreshToken(refreshToken: String)
}

extension AuthService: TargetType {
    
    var path: String {
        switch self {
        case .login:
            return "/v1/login"
        case .register:
            return "/v1/register"
        case .getUserProfile:
            return "/v1/user/profile"
        case .getUserId:
            return "/v1/user/id"
        case .refreshToken:
            return "/v1/refresh"
        }
    }
    
    var method: Moya.Method {
            switch self {
            case .getUserProfile, .getUserId:
                return .get
            case .login, .register, .refreshToken:
                return .post
            }
        }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .register(let request):
            return .requestJSONEncodable(request)
        case .getUserProfile:
            return .requestPlain
        case .getUserId:
            return .requestPlain
        case .refreshToken(let refreshToken):
            return .requestParameters(
                parameters: ["refreshToken": refreshToken],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return """
            {
                "accessToken": "eyJhbGciOiJIUzUxMiJ9...",
                "refreshToken": "eyJhbGciOiJIUzUxMiJ9...",
                "expiresIn": 3600,
                "refreshExpiresIn": 86400,
                "tokenType": "Bearer"
            }
            """.data(using: .utf8)!
        case .register:
            return """
            {
                "id": 1,
                "username": "user123",
                "firstName": "Иван",
                "lastName": "Иванов",
                "phone": "+79278580984",
                "email": "ivan@example.com"
            }
            """.data(using: .utf8)!
        case .getUserProfile:
            return """
            {
                "id": 1,
                "username": "user123",
                "firstName": "Иван",
                "lastName": "Иванов",
                "phone": "+79278580984",
                "email": "ivan@example.com"
            }
            """.data(using: .utf8)!
        case .refreshToken:
            return """
            {
                "accessToken": "new_access_token",
                "refreshToken": "new_refresh_token",
                "expiresIn": 3600,
                "refreshExpiresIn": 86400,
                "tokenType": "Bearer"
            }
            """.data(using: .utf8)!
        case .getUserId:
            return "1".data(using: .utf8)!

        }
    }
}
