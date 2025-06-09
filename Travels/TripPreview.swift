//
//  TripPreview.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation

enum AvatarType {
    case image(String)
    case initial(String)
}

enum TripStatus {
    case pending
    case confirmed
}

struct TripPreview {
    let id: Int
    let title: String
    let subtitle: String
    let avatar: AvatarType
    var status: TripStatus? = nil
    var dateInfo: String? = nil
}
