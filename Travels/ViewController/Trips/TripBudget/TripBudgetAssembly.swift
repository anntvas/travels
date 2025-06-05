//
//  TripBudgetAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

enum TripBudgetAssembly {
    static func build(user: User?) -> UIViewController {
        let model = TripBudgetModel()
        let router = TripBudgetRouter()
        let presenter = TripBudgetPresenter(model: model, router: router, currentUser: user)
        let view = TripBudgetViewController(presenter: presenter)
        presenter.attachView(view)
        return view
    }
}
