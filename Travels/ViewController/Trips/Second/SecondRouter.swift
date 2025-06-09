//
//  SecondRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import UIKit

protocol SecondRouterProtocol {
    func openCreateTrip()
    func showTripDetails(_ trip: Trip)
}

final class SecondRouter: SecondRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func openCreateTrip() {
        let tripVC = TripDetailsAssembly.build()
        viewController?.present(UINavigationController(rootViewController: tripVC), animated: true)
    }
    
    func showTripDetails(_ trip: Trip) {
        let detailVC = TripDetailAssembly.build(tripId: Int(trip.id))
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }

}
