//
//  FirstViewModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import CoreData

protocol FirstModelProtocol {
    func fetchUserAndTrips(completion: @escaping (User?, [Trip]) -> Void)
}

final class FirstModel: FirstModelProtocol {
    func fetchUserAndTrips(completion: @escaping (User?, [Trip]) -> Void) {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else {
            completion(nil, [])
            return
        }

        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %lld", Int64(userId))

        guard let user = try? DataController.shared.context.fetch(userRequest).first else {
            completion(nil, [])
            return
        }

        let tripRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripRequest.predicate = NSPredicate(format: "createdBy == %lld", user.id)
        tripRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]

        let trips = (try? DataController.shared.context.fetch(tripRequest)) ?? []
        completion(user, trips)
    }
}
