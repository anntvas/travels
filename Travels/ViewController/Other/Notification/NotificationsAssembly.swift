//
//  NotificationAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

enum NotificationsAssembly {
    static func build() -> UIViewController {
        let view = NotificationsViewController()
        let model = NotificationsModel()
        let presenter = NotificationsPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
