//
//  TripParticipantsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripParticipantsRouterProtocol {
    func navigateToBudgetScreen(user: User?)
    func setViewController(_ vc: UIViewController)
}

final class TripParticipantsRouter: TripParticipantsRouterProtocol {
    private weak var viewController: UIViewController?
    
    func setViewController(_ vc: UIViewController) {
        self.viewController = vc
    }
    
    func navigateToBudgetScreen(user: User?) {
        let budgetVC = TripBudgetAssembly.build(user: user)
        viewController?.navigationController?.pushViewController(budgetVC, animated: true)
    }
}
