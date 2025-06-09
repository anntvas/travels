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

protocol NetworkManagerProtocol {
    // MARK: - Auth Methods
    func login(request: LoginRequest, completion: @escaping (Result<TokenResponse, Error>) -> Void)
    func register(request: RegisterRequest, completion: @escaping (Result<UserResponse, Error>) -> Void)
    func getUserProfile(completion: @escaping (Result<UserResponse, Error>) -> Void)
    func getCurrentUserId(completion: @escaping (Result<Int, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<TokenResponse, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)

    
    // MARK: - Trip Methods
    func createTrip(trip: TripRequest, completion: @escaping (Result<TripResponse, Error>) -> Void)
    func getTrips(completion: @escaping (Result<[TripResponse], Error>) -> Void)
    func getTripDetails(tripId: Int, completion: @escaping (Result<TripResponse, Error>) -> Void)
    func updateTrip(tripId: Int, trip: TripRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTrip(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func getPendingTrips(completion: @escaping (Result<[TripResponse], Error>) -> Void)
    func getConfirmedTrips(completion: @escaping (Result<[TripResponse], Error>) -> Void)
    
    // MARK: - Participant Methods
    func listParticipants(tripId: Int, completion: @escaping (Result<[ParticipantResponse], Error>) -> Void)
    func addParticipant(tripId: Int, participant: ParticipantRequest,
                      completion: @escaping (Result<ParticipantResponse, Error>) -> Void)
    func deleteParticipant(tripId: Int, participantId: Int,
                         completion: @escaping (Result<Void, Error>) -> Void)
    func confirmParticipation(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func cancelParticipation(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchParticipants(
        tripId: Int,
        completion: @escaping (Result<[ParticipantResponse], Error>) -> Void
    )
    func setBudget(tripId: Int, request: BudgetRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func getBudget(tripId: Int, completion: @escaping (Result<BudgetResponse, Error>) -> Void)
    
    func addExpense(tripId: Int, request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func listExpenses(tripId: Int, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) 
    func getMyExpenses(tripId: Int, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void)
    
    func getAllBudgetCategories(completion: @escaping (Result<[BudgetCategoryLookup], Error>) -> Void)
    func updateUserProfile(request: UserRequest, completion: @escaping (Result<Void, Error>) -> Void)

}

final class NetworkManager: NetworkManagerProtocol {
    
    func fetchParticipants(
        tripId: Int,
        completion: @escaping (Result<[ParticipantResponse], Error>) -> Void
    ) {
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

    
    static let shared = NetworkManager()
    private let keychain = KeychainSwift()
    
    private lazy var authProvider: MoyaProvider<AuthService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<AuthService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain)
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
    
    private lazy var budgetProvider: MoyaProvider<BudgetService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<BudgetService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<BudgetService>(plugins: [authPlugin])
        #endif
    }()
    
    private lazy var expenseProvider: MoyaProvider<ExpenseService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<ExpenseService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<ExpenseService>(plugins: [authPlugin])
        #endif
    }()
    
    private lazy var settlementProvider: MoyaProvider<SettlementService> = {
        #if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let logger = NetworkLoggerPlugin(configuration: config)
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<SettlementService>(plugins: [authPlugin, logger])
        #else
        let authPlugin = AuthPlugin(keychain: self.keychain)
        return MoyaProvider<SettlementService>(plugins: [authPlugin])
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
    
    func getCurrentUserId(completion: @escaping (Result<Int, Error>) -> Void) {
        authProvider.request(.getUserId) { result in
            switch result {
            case .success(let response):
                do {
                    let id = try JSONDecoder().decode(Int.self, from: response.data)
                    completion(.success(id))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserProfile(request: UserRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        authProvider.request(.updateUserProfile(request: request)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    completion(.failure(NSError(domain: "", code: response.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: message])))
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
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = keychain.get("refreshToken") else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Refresh token not found"])))
            return
        }

        authProvider.request(.logout(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    // Удаляем токены из keychain
                    self.keychain.delete("accessToken")
                    self.keychain.delete("refreshToken")
                    completion(.success(()))
                } else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    completion(.failure(NSError(domain: "", code: response.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: message])))
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
        participantProvider.request(.deleteParticipant(tripId: tripId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func confirmParticipation(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        participantProvider.request(.confirmParticipation(tripId: tripId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelParticipation(tripId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        participantProvider.request(.cancelParticipation(tripId: tripId)) { result in
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
    func setBudget(tripId: Int, request: BudgetRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        budgetProvider.request(.setBudget(tripId: tripId, budget: request)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getBudget(tripId: Int, completion: @escaping (Result<BudgetResponse, Error>) -> Void) {
        budgetProvider.request(.getBudget(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let budget = try JSONDecoder().decode(BudgetResponse.self, from: response.data)
                    completion(.success(budget))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getAllBudgetCategories(completion: @escaping (Result<[BudgetCategoryLookup], Error>) -> Void) {
        budgetProvider.request(.getAllCategories) { result in
            switch result {
            case .success(let response):
                do {
                    let categories = try JSONDecoder().decode([BudgetCategoryLookup].self, from: response.data)
                    completion(.success(categories))
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
    func addExpense(tripId: Int, request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        expenseProvider.request(.addExpense(tripId: tripId, expense: request)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    completion(.failure(NSError(domain: "", code: response.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: message])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func listExpenses(tripId: Int, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) {
        expenseProvider.request(.listExpenses(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let expenses = try JSONDecoder().decode([ExpenseResponse].self, from: response.data)
                    completion(.success(expenses))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getMyExpenses(tripId: Int, completion: @escaping (Result<[ExpenseResponse], any Error>) -> Void) {
        expenseProvider.request(.getMyExpenses(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let expenses = try JSONDecoder().decode([ExpenseResponse].self, from: response.data)
                    completion(.success(expenses))
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
    func getPendingTrips(completion: @escaping (Result<[TripResponse], Error>) -> Void) {
        tripProvider.request(.getPendingTrips) { result in
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
    
    func getConfirmedTrips(completion: @escaping (Result<[TripResponse], Error>) -> Void) {
        tripProvider.request(.getConfirmedTrips) { result in
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
    
    func getSettlements(tripId: Int, completion: @escaping (Result<[SettlementItem], Error>) -> Void) {
        settlementProvider.request(.getSettlements(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let settlementResponse = try JSONDecoder().decode(SettlementResponse.self, from: response.data)
                    completion(.success(settlementResponse.settlements))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSettlementsReceivable(tripId: Int, completion: @escaping (Result<[SettlementItem], Error>) -> Void) {
        settlementProvider.request(.getSettlementsReceivable(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let settlements = try JSONDecoder().decode([SettlementItem].self, from: response.data)
                    completion(.success(settlements))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getSettlementsPayable(tripId: Int, completion: @escaping (Result<[SettlementItem], Error>) -> Void) {
        settlementProvider.request(.getSettlementsPayable(tripId: tripId)) { result in
            switch result {
            case .success(let response):
                do {
                    let settlements = try JSONDecoder().decode([SettlementItem].self, from: response.data)
                    completion(.success(settlements))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
