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
    case deleteParticipant(tripId: Int, participantId: Int)
    case confirmParticipation(tripId: Int, participantId: Int)
    case cancelParticipation(tripId: Int, participantId: Int)
}

extension ParticipantService: TargetType {

    var path: String {
        switch self {
        case .listParticipants(let tripId), .addParticipant(let tripId, _):
            return "/v1/trips/\(tripId)/participants"
        case .deleteParticipant(let tripId, let participantId),
             .confirmParticipation(let tripId, let participantId),
             .cancelParticipation(let tripId, let participantId):
            return "/v1/trips/\(tripId)/participants/\(participantId)/\(self.pathSuffix)"
        }
    }
    
    private var pathSuffix: String {
        switch self {
        case .deleteParticipant:
            return ""
        case .confirmParticipation:
            return "confirm"
        case .cancelParticipation:
            return "cancel"
        default:
            return ""
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

struct ParticipantRequest: Codable {
    let name: String
    let contact: String
}

struct ParticipantResponse: Codable {
    let id: Int
    let tripId: Int
    let name: String
    let contact: String
    let confirmed: Bool
}
