//
//  BudgetCategoriesRouter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit

protocol BudgetCategoriesRouterProtocol {
    func navigateToBudgetAllocation(with user: User)
}

final class BudgetCategoriesRouter: BudgetCategoriesRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToBudgetAllocation(with user: User) {
        let allocationVC = BudgetAllocationViewController()
//        allocationVC.currentUser = user
        viewController?.navigationController?.pushViewController(allocationVC, animated: true)
    }
}
