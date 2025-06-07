//
//  BudgetCategoriesAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit
enum BudgetCategoriesAssembly {
    static func build(with user: User) -> UIViewController {
        let view = BudgetCategoriesViewController()
        let model = BudgetCategoriesModel()
        let router = BudgetCategoriesRouter(viewController: view)
        let presenter = BudgetCategoriesPresenter(
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
