//
//  BudgetAllocationAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

enum BudgetAllocationAssembly {
    static func build(tripId: Int, budgetRequest: BudgetRequest) -> UIViewController {
        let view = BudgetAllocationViewController()
        let model = BudgetAllocationModel(budgetRequest: budgetRequest)
        let router = BudgetAllocationRouter(viewController: view)
        let presenter = BudgetAllocationPresenter(
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
