//
//  TripBudgetRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

protocol TripBudgetRouterProtocol {
    func navigateToConfirm(from vc: UIViewController, user: User?)
}

final class TripBudgetRouter: TripBudgetRouterProtocol {
    func navigateToConfirm(from vc: UIViewController, user: User?) {
        let confirmVC = TripBudgetConfirmAssembly.build(user: user)
        vc.navigationController?.pushViewController(confirmVC, animated: true)
    }
}
