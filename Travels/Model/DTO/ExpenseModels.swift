//
//  ExpenseModels.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation

struct ExpenseRequest: Codable {
    let description: String
    let amount: Double
    let paidBy: Int
    let category: Int?
    let beneficiaries: [Int]
}

struct ExpenseResponse: Codable {
    let id: Int
    let tripId: Int
    let description: String
    let amount: Double
    let paidBy: Int
    let category: Int?
    let beneficiaries: [Int]
}
