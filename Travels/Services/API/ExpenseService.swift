//
//  ExpenseService.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation
import Moya

enum ExpenseService {
    case listExpenses(tripId: Int)
    case addExpense(tripId: Int, expense: ExpenseRequest)
    case deleteExpense(tripId: Int, expenseId: Int)
    case getMyExpenses(tripId: Int)
}

extension ExpenseService: TargetType {

    var path: String {
        switch self {
        case .listExpenses(let tripId), .addExpense(let tripId, _):
            return "/v1/trips/\(tripId)/expenses"
        case .deleteExpense(let tripId, let expenseId):
            return "/v1/trips/\(tripId)/expenses/\(expenseId)"
        case .getMyExpenses(let tripId):
            return "/v1/trips/\(tripId)/expenses/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .listExpenses, .getMyExpenses:
            return .get
        case .addExpense:
            return .post
        case .deleteExpense:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .addExpense(_, let expense):
            return .requestJSONEncodable(expense)
        case .listExpenses, .deleteExpense, .getMyExpenses:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}


extension ExpenseService: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? { .bearer }
}
