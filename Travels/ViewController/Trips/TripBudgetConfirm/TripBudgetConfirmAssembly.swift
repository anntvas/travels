//
//  TripBudgetConfirmAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit
enum TripBudgetConfirmAssembly {
    static func build(with user: User) -> UIViewController {
        let view = TripBudgetConfirmViewController()
        let model = TripBudgetConfirmModel()
        let router = TripBudgetConfirmRouter(viewController: view)
        let presenter = TripBudgetConfirmPresenter(
            view: view,
            model: model,
            router: router,
            user: user
        )
        
        view.presenter = presenter
        view.currentUser = user
        return view
    }
}
