//
//  TripParticipantsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripParticipantsRouterProtocol {
    func navigateToTripBudget(with user: User, participants: [Participant])
}

import UIKit

final class TripParticipantsRouter: TripParticipantsRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToTripBudget(with user: User, participants: [Participant]) {
        let budgetVC = TripBudgetViewController()
        budgetVC.currentUser = user
//        budgetVC.participants = participants
        viewController?.navigationController?.pushViewController(budgetVC, animated: true)
    }
}
