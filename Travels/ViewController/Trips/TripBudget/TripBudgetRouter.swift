//
//  TripBudgetRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripBudgetRouterProtocol {
    func navigateToBudgetConfirm(tripId: Int, budget: BudgetRequest)
}
import UIKit

final class TripBudgetRouter: TripBudgetRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToBudgetConfirm(tripId: Int, budget: BudgetRequest) {
        let categoriesVC =  BudgetCategoriesAssembly.build(tripId: tripId, budgetRequest: budget)
        viewController?.navigationController?.pushViewController(categoriesVC, animated: true)
    }
}
