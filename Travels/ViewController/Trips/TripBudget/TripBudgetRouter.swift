//
//  TripBudgetRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripBudgetRouterProtocol {
    func navigateToBudgetConfirm(with user: User)
}
import UIKit

final class TripBudgetRouter: TripBudgetRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToBudgetConfirm(with user: User) {
        let confirmVC = TripBudgetConfirmViewController()
        confirmVC.currentUser = user
        viewController?.navigationController?.pushViewController(confirmVC, animated: true)
    }
}
