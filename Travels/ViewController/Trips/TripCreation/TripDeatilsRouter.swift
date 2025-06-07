//
//  TripDeatilsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripDetailsRouterProtocol {
    func navigateToParticipants(user: User?)
}

final class TripDetailsRouter: TripDetailsRouterProtocol {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateToParticipants(user: User?) {
 //       guard let user = user else { return }
//        let participantsVC = TripParticipantsAssembly.build(user: user)
//        viewController?.navigationController?.pushViewController(participantsVC, animated: true)
    }
}
