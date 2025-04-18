//
//  Trip+CoreDataClass.swift
//  Travels
//
//  Created by Anna on 18.04.2025.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    @discardableResult
        static func create(
            title: String,
            destination: String,
            startDate: Date,
            endDate: Date,
            user: User,
            in context: NSManagedObjectContext
        ) -> Trip {
            let trip = Trip(context: context)
            trip.id = UUID()
            trip.title = title
            trip.destination = destination
            trip.startDate = startDate
            trip.endDate = endDate
            trip.user = user
            
            do {
                try context.save()
            } catch {
                print("Failed to save trip: \(error)")
            }
            
            return trip
        }
        
        /// Обновление существующей поездки
        func update(
            title: String? = nil,
            destination: String? = nil,
            startDate: Date? = nil,
            endDate: Date? = nil
        ) {
            if let title = title { self.title = title }
            if let destination = destination { self.destination = destination }
            if let startDate = startDate { self.startDate = startDate }
            if let endDate = endDate { self.endDate = endDate }
            
            do {
                try managedObjectContext?.save()
            } catch {
                print("Failed to update trip: \(error)")
            }
        }
        
        /// Удаление поездки
        func delete() {
            managedObjectContext?.delete(self)
            
            do {
                try managedObjectContext?.save()
            } catch {
                print("Failed to delete trip: \(error)")
            }
        }
        
        /// Получение всех поездок пользователя
        static func fetchTrips(for user: User, in context: NSManagedObjectContext) -> [Trip] {
            let request: NSFetchRequest<Trip> = Trip.fetchRequest()
            request.predicate = NSPredicate(format: "user == %@", user)
            request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
            
            do {
                return try context.fetch(request)
            } catch {
                print("Failed to fetch trips: \(error)")
                return []
            }
        }
}
