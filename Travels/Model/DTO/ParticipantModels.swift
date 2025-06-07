//
//  ParticipantModels.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
struct ParticipantRequest: Codable {
    let phone: String
}
struct ParticipantResponse: Codable {
    let id: Int
    let tripId: Int
    let name: String
    let contact: String
    let confirmed: Bool
}
