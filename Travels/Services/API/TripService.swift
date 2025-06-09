//
//  TripService.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import Moya
import Foundation

enum TripService {
    case createTrip(trip: TripRequest)
    case getTrips
    case getTripDetails(tripId: Int)
    case updateTrip(tripId: Int, trip: TripRequest)
    case deleteTrip(tripId: Int)
    case getPendingTrips
    case getConfirmedTrips
}

extension TripService: TargetType {
    
    var path: String {
        switch self {
        case .createTrip, .getTrips:
            return "/v1/trips"
        case .getTripDetails(let tripId), .updateTrip(let tripId, _), .deleteTrip(let tripId):
            return "/v1/trips/\(tripId)"
        case .getPendingTrips:
            return "/v1/trips/pending"
        case .getConfirmedTrips:
            return "/v1/trips/confirmed"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTrip:
            return .post
        case .getTrips, .getTripDetails, .getPendingTrips, .getConfirmedTrips:
            return .get
        case .updateTrip:
            return .put
        case .deleteTrip:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .createTrip(let trip), .updateTrip(_, let trip):
            return .requestJSONEncodable(trip)
        case .getTrips, .getTripDetails, .deleteTrip, .getConfirmedTrips, .getPendingTrips:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
