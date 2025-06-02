//
//  NetworkManager.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import Moya
import Alamofire
import KeychainSwift
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let keychain = KeychainSwift()
        
    private lazy var authProvider: MoyaProvider<AuthService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain) // Создаем плагин с keychain
        return MoyaProvider<AuthService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain) // Создаем плагин с keychain
        return MoyaProvider<AuthService>(plugins: [authPlugin])
        #endif
    }()
    private lazy var tripProvider: MoyaProvider<TripService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<TripService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<TripService>(plugins: [authPlugin])
        #endif
    }()
    private lazy var participantProvider: MoyaProvider<ParticipantService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<ParticipantService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<ParticipantService>(plugins: [authPlugin])
        #endif
    }()
    
    // MARK: - Auth Methods
    
    func login(request: LoginRequest, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        authProvider.request(.login(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    completion(.success(tokenResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func register(request: RegisterRequest, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        authProvider.request(.register(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: response.data)
                    completion(.success(userResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserProfile(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        authProvider.request(.getUserProfile) { result in
            switch result {
            case .success(let response):
                // Добавим проверку статус-кода
                if response.statusCode == 403 {
                    completion(.failure(NSError(domain: "Auth", code: 403,
                        userInfo: [NSLocalizedDescriptionKey: "Доступ запрещен. Неверные права доступа"])))
                    return
                }
                
                do {
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: response.data)
                    completion(.success(userResponse))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshToken(completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        guard let refreshToken = keychain.get("refreshToken") else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Refresh token not found"])))
            return
        }
        
        authProvider.request(.refreshToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    completion(.success(tokenResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkManager {

    // MARK: - Trip Methods
    
    func createTrip(trip: TripRequest, completion: @escaping (Result<TripResponse, Error>) -> Void) {
        tripProvider.request(.createTrip(trip: trip)) { result in
            switch result {
            case .success(let response):
                do {
                    let tripResponse = try JSONDecoder().decode(TripResponse.self, from: response.data)
                    completion(.success(tripResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrips(completion: @escaping (Result<[TripResponse], Error>) -> Void) {
        tripProvider.request(.getTrips) { result in
            switch result {
            case .success(let response):
                do {
                    let trips = try JSONDecoder().decode([TripResponse].self, from: response.data)
                    completion(.success(trips))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTripDetails(tripId: Int, completion: @escaping (Result<TripResponse, Error>) -> Void) {
        tripProvider.request(.getTripDetails(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let trip = try JSONDecoder().decode(TripResponse.self, from: response.data)
                    completion(.success(trip))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTrip(tripId: Int, trip: TripRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        tripProvider.request(.updateTrip(tripId: tripId, trip: trip)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTrip(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        tripProvider.request(.deleteTrip(tripId: tripId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkManager {

    
    // MARK: - Participant Methods
    
    func listParticipants(tripId: Int, completion: @escaping (Result<[ParticipantResponse], Error>) -> Void) {
        participantProvider.request(.listParticipants(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let participants = try JSONDecoder().decode([ParticipantResponse].self, from: response.data)
                    completion(.success(participants))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addParticipant(tripId: Int, participant: ParticipantRequest, completion: @escaping (Result<ParticipantResponse, Error>) -> Void) {
        participantProvider.request(.addParticipant(tripId: tripId, participant: participant)) { result in
            switch result {
            case .success(let response):
                do {
                    let participant = try JSONDecoder().decode(ParticipantResponse.self, from: response.data)
                    completion(.success(participant))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteParticipant(tripId: Int, participantId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        participantProvider.request(.deleteParticipant(tripId: tripId, participantId: participantId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func confirmParticipation(tripId: Int, participantId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        participantProvider.request(.confirmParticipation(tripId: tripId, participantId: participantId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelParticipation(tripId: Int, participantId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        participantProvider.request(.cancelParticipation(tripId: tripId, participantId: participantId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
