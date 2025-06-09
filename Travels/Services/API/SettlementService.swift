//
//  SettlementService.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation
import Moya

enum SettlementService {
    case getSettlements(tripId: Int)
    case getSettlementsReceivable(tripId: Int)
    case getSettlementsPayable(tripId: Int)
    case requestConfirmation(tripId: Int, settlementId: Int)
    case confirmDebtReturn(tripId: Int, settlementId: Int)
}

extension SettlementService: TargetType {
    
    var path: String {
        switch self {
        case .getSettlements(let tripId):
            return "/v1/trips/\(tripId)/settlements"
        case .getSettlementsReceivable(let tripId):
            return "/v1/trips/\(tripId)/settlements/receivable"
        case .getSettlementsPayable(let tripId):
            return "/v1/trips/\(tripId)/settlements/payable"
        case .requestConfirmation(let tripId, let id):
            return "/v1/trips/\(tripId)/settlements/\(id)/request-confirmation"
        case .confirmDebtReturn(let tripId, let id):
            return "/v1/trips/\(tripId)/settlements/\(id)/confirm"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSettlements, .getSettlementsReceivable, .getSettlementsPayable:
            return .get
        case .requestConfirmation:
            return .post
        case .confirmDebtReturn:
            return .post
            
        }
    }
        
    var task: Task {
        return .requestPlain
    }
        
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

extension SettlementService: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? { .bearer }
}
