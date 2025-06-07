//
//  FirstRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol FirstRouterProtocol {
    func openCreateTrip()
    func showParticipants(for trip: Trip?)
}

final class FirstRouter: FirstRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func openCreateTrip() {
        let vc = TripDetailsAssembly.build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func showParticipants(for trip: Trip?) {
        // Реализация перехода к участникам
        // let participantsVC = TripParticipantsAssembly.build(trip: trip)
        // viewController?.navigationController?.pushViewController(participantsVC, animated: true)
    }
}
