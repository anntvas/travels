//
//  BudgetCategoriesRouter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit

protocol BudgetCategoriesRouterProtocol {
    func navigateToBudgetAllocation(tripId: Int, budgetRequest: BudgetRequest)
}

final class BudgetCategoriesRouter: BudgetCategoriesRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToBudgetAllocation(tripId: Int, budgetRequest: BudgetRequest) {
        let allocationVC = BudgetAllocationAssembly.build(tripId: tripId, budgetRequest: budgetRequest)
        viewController?.navigationController?.pushViewController(allocationVC, animated: true)
    }
}
