//
//  TripModels.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation

struct TripRequest: Codable {
    let title: String
    let description: String?
    let startDate: String
    let endDate: String
    let departureCity: String
    let destinationCity: String
    let createdBy: Int64
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case startDate
        case endDate
        case departureCity
        case destinationCity
        case createdBy
    }
}

struct TripResponse: Codable {
    let id: Int
    let title: String
    let description: String?
    let startDate: String
    let endDate: String
    let departureCity: String
    let destinationCity: String
    let createdBy: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case startDate
        case endDate
        case departureCity
        case destinationCity
        case createdBy
    }
}
