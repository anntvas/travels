//
//  SettlementModels.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation

struct SettlementItem: Codable {
    let from: Int
    let to: Int
    let amount: Double
    let status: SettlementStatus
}

struct SettlementResponse: Codable {
    let settlements: [SettlementItem]
}

enum SettlementStatus: String, Codable {
    case pending = "PENDING"
    case requested = "REQUESTED"
    case confirmed = "CONFIRMED"
}
