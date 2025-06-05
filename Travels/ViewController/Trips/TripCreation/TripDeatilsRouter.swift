//
//  TripDeatilsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripDetailsRouterProtocol {
    func navigateToParticipants(user: User?)
    func setViewController(_ vc: UIViewController)
}

final class TripDetailsRouter: TripDetailsRouterProtocol {
    private weak var viewController: UIViewController?

    func setViewController(_ vc: UIViewController) {
        self.viewController = vc
    }

    func navigateToParticipants(user: User?) {
        let participantsVC = TripParticipantsAssembly.build(user: user)
        viewController?.navigationController?.pushViewController(participantsVC, animated: true)
    }
}
