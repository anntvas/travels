//
//  BudgetCategoriesAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit
enum BudgetCategoriesAssembly {
    static func build(tripId: Int, budgetRequest: BudgetRequest) -> UIViewController {
        let view = BudgetCategoriesViewController()
        let model = BudgetCategoriesModel()
        let router = BudgetCategoriesRouter(viewController: view)
        let presenter = BudgetCategoriesPresenter(
            view: view,
            model: model,
            router: router,
            tripId: tripId,
            budgetRequest: budgetRequest
        )
        
        view.presenter = presenter
        return view
    }
}
