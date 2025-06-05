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
    func setViewController(_ vc: UIViewController)
}

final class FirstRouter: FirstRouterProtocol {
    private weak var viewController: UIViewController?

    func setViewController(_ vc: UIViewController) {
        self.viewController = vc
    }
    
    func openCreateTrip() {
        let vc = TripDetailsAssembly.build()
        viewController?.present(UINavigationController(rootViewController: vc), animated: true)
    }

    func showParticipants(for trip: Trip?) {
        guard let trip = trip else { return }
        let participantsVC = TripParticipantsViewController()
        participantsVC.participants = trip.participants as? Set<Participant> ?? []
        viewController?.present(participantsVC, animated: true)
    }
}
