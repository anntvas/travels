//
//  TripDeatilsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol TripDetailsRouterProtocol {
    func navigateToParticipants(tripId: Int)
}

final class TripDetailsRouter: TripDetailsRouterProtocol {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func navigateToParticipants(tripId: Int) {
        print("Навигация к участникам с tripId: \(tripId)")
        let participantsVC = TripParticipantsAssembly.build(tripId: tripId)
        print("VC создан: \(participantsVC)")
        viewController?.navigationController?.pushViewController(participantsVC, animated: true)

    }

}
