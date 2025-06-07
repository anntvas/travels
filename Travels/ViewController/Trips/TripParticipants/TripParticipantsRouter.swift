//
//  TripParticipantsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripParticipantsRouterProtocol {
    func navigateToTripBudget(tripId: Int)
}

import UIKit

final class TripParticipantsRouter: TripParticipantsRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToTripBudget(tripId: Int) {
        let budgetVC = TripBudgetAssembly.build(tripId: tripId)
        viewController?.navigationController?.pushViewController(budgetVC, animated: true)
    }
}
