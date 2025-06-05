//
//  TripBudgetRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripBudgetRouterProtocol {
    func navigateToConfirm(user: User?)
}

final class TripBudgetRouter: TripBudgetRouterProtocol {
    
    weak var viewController: UIViewController?

    func navigateToConfirm(user: User?) {
        let confirmVC = TripBudgetConfirmAssembly.build(user: user)
        viewController?.navigationController?.pushViewController(confirmVC, animated: true)
    }
}
