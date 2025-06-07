//
//  TripBudgetAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

enum TripBudgetAssembly {
    static func build(tripId: Int) -> UIViewController {
        let view = TripBudgetViewController()
        let model = TripBudgetModel()
        let router = TripBudgetRouter(viewController: view)
        let presenter = TripBudgetPresenter(
            view: view,
            model: model,
            router: router,
            tripId: tripId
        )
        
        view.presenter = presenter
        return view
    }
}
