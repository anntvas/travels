//
//  TripBudgetAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

enum TripBudgetAssembly {
    static func build(user: User?) -> UIViewController {
        let view = TripBudgetViewController()
        let model = TripBudgetModel()
        let router = TripBudgetRouter()
        let presenter = TripBudgetPresenter(view: view, model: model, router: router, currentUser: user)
        view.presenter = presenter
        return view
    }
}
