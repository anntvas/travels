//
//  TripParticipantsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

protocol TripParticipantsRouterProtocol {
    func navigateToBudgetScreen(from vc: UIViewController, user: User?)
}

final class TripParticipantsRouter: TripParticipantsRouterProtocol {
    func navigateToBudgetScreen(from vc: UIViewController, user: User?) {
        let budgetVC = TripBudgetViewController()
        budgetVC.currentUser = user
        vc.navigationController?.pushViewController(budgetVC, animated: true)
    }
}
