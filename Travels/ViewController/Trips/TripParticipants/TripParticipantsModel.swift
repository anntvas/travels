//
//  TripParticipantsModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import CoreData

protocol TripParticipantsModelProtocol {
    func createParticipant(name: String, phone: String) -> Participant
}

final class TripParticipantsModel: TripParticipantsModelProtocol {
    func createParticipant(name: String, phone: String) -> Participant {
        let context = DataController.shared.context
        let participant = Participant(context: context)
        participant.name = name
        participant.contact = phone
        participant.confirmed = true
        return participant
    }
}
