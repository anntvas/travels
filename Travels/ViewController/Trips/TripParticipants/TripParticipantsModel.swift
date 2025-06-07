//
//  TripParticipantsModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import CoreData

protocol TripParticipantsModelProtocol {
    func addParticipant(name: String, phone: String, completion: @escaping (Result<Participant, Error>) -> Void)
    func deleteParticipant(_ participant: Participant)
    func fetchParticipants() -> [Participant]
}

import CoreData

final class TripParticipantsModel: TripParticipantsModelProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = DataController.shared.context) {
        self.context = context
    }
    
    func addParticipant(name: String, phone: String, completion: @escaping (Result<Participant, Error>) -> Void) {
        let participant = Participant(context: context)
        participant.name = name
        participant.contact = phone
        participant.confirmed = true
        
        do {
            try context.save()
            completion(.success(participant))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteParticipant(_ participant: Participant) {
        context.delete(participant)
        try? context.save()
    }
    
    func fetchParticipants() -> [Participant] {
        // В реальном приложении здесь должна быть логика загрузки участников
        // Пока возвращаем пустой массив
        return []
    }
}
