//
//  BudgetAllocationRouter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

protocol BudgetAllocationRouterProtocol {
    func navigateAfterTripCreation()
}

final class BudgetAllocationRouter: BudgetAllocationRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateAfterTripCreation() {
        viewController?.dismiss(animated: true) {
            NotificationCenter.default.post(
                name: NSNotification.Name("TripCreated"),
                object: nil
            )
        }
    }
}
