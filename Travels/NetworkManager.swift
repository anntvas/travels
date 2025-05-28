//
//  NetworkManager.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case authFailed
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://your-api-domain.com/api/v1"
    private let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Auth API
    func login(phone: String, password: String, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/login"
        let params = ["phone": phone, "password": password]
        
        request(endpoint: endpoint, method: "POST", parameters: params, completion: completion)
    }
    
    func register(userData: RegistrationData, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/register"
        
        request(endpoint: endpoint, method: "POST", parameters: userData.dictionary, completion: completion)
    }
    
    // MARK: - Profile API
    func fetchUserProfile(completion: @escaping (Result<UserProfile, NetworkError>) -> Void) {
        let endpoint = "/profile"
        
        request(endpoint: endpoint, method: "GET", completion: completion)
    }
    
    func updateAvatar(imageData: Data, completion: @escaping (Result<UserProfile, NetworkError>) -> Void) {
        let endpoint = "/profile/avatar"
        
        upload(endpoint: endpoint, data: imageData, completion: completion)
    }
    
    // MARK: - Generic Request
    private func request<T: Decodable>(
        endpoint: String,
        method: String,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Добавляем токен если есть
        if let token = AuthService.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let params = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Обработка HTTP-статусов
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    AuthService.shared.logout()
                    completion(.failure(.authFailed))
                    return
                case 400...499:
                    if let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) {
                        completion(.failure(.serverError(errorResponse.message)))
                    } else {
                        completion(.failure(.serverError("Client error")))
                    }
                    return
                case 500...599:
                    completion(.failure(.serverError("Server error")))
                    return
                default:
                    break
                }
            }
            
            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    // MARK: - Upload
    private func upload<T: Decodable>(
        endpoint: String,
        data: Data,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthService.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        var body = Data()
        
        // Добавляем файл
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
