//
//  TripPreview.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import Foundation

enum AvatarType {
    case image(String) 
    case initial(String)
}

enum TripStatus {
    case invited
    case joined
    case past
}

struct TripPreview {
    let title: String
    let subtitle: String
    let avatar: AvatarType
    var status: TripStatus? = nil
    var dateInfo: String? = nil
}
