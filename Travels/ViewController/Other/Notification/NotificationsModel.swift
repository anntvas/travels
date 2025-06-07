//
//  NotificationsModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol NotificationsModelProtocol {
    func fetchNotifications() -> [String]
    func deleteNotification(at index: Int)
    func clearAllNotifications()
}

final class NotificationsModel: NotificationsModelProtocol {
    private var notifications: [String] = [
        "У вас есть долг",
        "Дима за вас заплатил"
    ]
    
    func fetchNotifications() -> [String] {
        return notifications
    }
    
    func deleteNotification(at index: Int) {
        guard index >= 0 && index < notifications.count else { return }
        notifications.remove(at: index)
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
    }
}
