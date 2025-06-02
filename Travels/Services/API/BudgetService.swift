//
//  BudgetService.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation
import Moya

enum BudgetService {
    case getBudget(tripId: Int)
    case setBudget(tripId: Int, budget: BudgetRequest)
    case updateBudget(tripId: Int, budget: BudgetRequest)
    case getCategories(tripId: Int)
}

extension BudgetService: TargetType {

    var path: String {
        switch self {
        case .getBudget(let tripId),
             .setBudget(let tripId, _),
             .updateBudget(let tripId, _):
            return "/v1/trips/\(tripId)/budget"
        case .getCategories(let tripId):
            return "/v1/trips/\(tripId)/budget/categories"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getBudget, .getCategories:
            return .get
        case .setBudget:
            return .post
        case .updateBudget:
            return .put
        }
    }

    var task: Task {
        switch self {
        case .setBudget(_, let budget), .updateBudget(_, let budget):
            return .requestJSONEncodable(budget)
        case .getBudget, .getCategories:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

