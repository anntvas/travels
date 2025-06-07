//
//  TripParticipantsModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import CoreData

protocol TripParticipantsModelProtocol {
    func addParticipant(to tripId: Int, phone: String, completion: @escaping (Result<ParticipantResponse, Error>) -> Void)
    func fetchParticipants(
        tripId: Int,
        completion: @escaping (Result<[ParticipantResponse], Error>) -> Void
    )

}



final class TripParticipantsModel: TripParticipantsModelProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func addParticipant(to tripId: Int, phone: String, completion: @escaping (Result<ParticipantResponse, Error>) -> Void) {
        networkManager.addParticipant(tripId: tripId, participant: ParticipantRequest(phone: phone), completion: completion)
    }
    
    func fetchParticipants(
        tripId: Int,
        completion: @escaping (Result<[ParticipantResponse], Error>) -> Void
    ) {
        networkManager.fetchParticipants(tripId: tripId, completion: completion)
    }
}

