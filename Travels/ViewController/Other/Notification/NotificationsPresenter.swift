//
//  NotificationsPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol NotificationsViewProtocol: AnyObject {
    func displayNotifications(_ notifications: [String])
    func showEmptyState()
    func showClearButton(enabled: Bool)
    func deleteRow(at indexPath: IndexPath)
}
protocol NotificationsPresenterProtocol {
    func viewDidLoad()
    func didTapClearButton()
    func didTapDelete(at index: Int)
}

final class NotificationsPresenter: NotificationsPresenterProtocol {
    private weak var view: NotificationsViewProtocol?
    private let model: NotificationsModelProtocol
    
    init(view: NotificationsViewProtocol, model: NotificationsModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        let notifications = model.fetchNotifications()
        view?.displayNotifications(notifications)
        view?.showClearButton(enabled: !notifications.isEmpty)
    }
    
    func didTapClearButton() {
        model.clearAllNotifications()
        view?.displayNotifications([])
        view?.showEmptyState()
    }
    
    func didTapDelete(at index: Int) {
        model.deleteNotification(at: index)
        let updatedNotifications = model.fetchNotifications()
        view?.displayNotifications(updatedNotifications)
    }
}
