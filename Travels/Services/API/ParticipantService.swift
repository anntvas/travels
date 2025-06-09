//
//  ParticipantService.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Moya
import Foundation

enum ParticipantService {
    case listParticipants(tripId: Int)
    case addParticipant(tripId: Int, participant: ParticipantRequest)
    case deleteParticipant(tripId: Int)
    case confirmParticipation(tripId: Int)
    case cancelParticipation(tripId: Int)
}

extension ParticipantService: TargetType {

    var path: String {
        switch self {
        case .listParticipants(let tripId), .addParticipant(let tripId, _):
            return "/v1/trips/\(tripId)/participants"
        case .deleteParticipant(let tripId):
            return "/v1/trips/\(tripId)/participants"
        case .cancelParticipation(let tripId):
            return "/v1/trips/\(tripId)/participants/сancel"
        case .confirmParticipation(let tripId):
            return "/v1/trips/\(tripId)/participants/confirm"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .listParticipants:
            return .get
        case .addParticipant:
            return .post
        case .deleteParticipant:
            return .delete
        case .confirmParticipation, .cancelParticipation:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .addParticipant(_, let participant):
            return .requestJSONEncodable(participant)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

extension ParticipantService: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? { .bearer }
}

