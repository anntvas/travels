//
//  TripBudgetConfirmRouter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit

protocol TripBudgetConfirmRouterProtocol {
    func navigateToBudgetCategories(with user: User)
}


final class TripBudgetConfirmRouter: TripBudgetConfirmRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToBudgetCategories(with user: User) {
        let categoriesVC = BudgetCategoriesViewController()
        categoriesVC.currentUser = user
        viewController?.navigationController?.pushViewController(categoriesVC, animated: true)
    }
}
