//
//  BudgetAllocationAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

enum BudgetAllocationAssembly {
    static func build() -> UIViewController {
        let view = BudgetAllocationViewController()
        let model = BudgetAllocationModel()
        let router = BudgetAllocationRouter(viewController: view)
        let presenter = BudgetAllocationPresenter(
            view: view,
            model: model,
            router: router
        )
        
        view.presenter = presenter
        return view
    }
}
