//
//  TripDeatilsRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

protocol TripDetailsRouterProtocol {
    func navigateToParticipants(from vc: UIViewController, user: User?)
}

final class TripDetailsRouter: TripDetailsRouterProtocol {
    func navigateToParticipants(from vc: UIViewController, user: User?) {
        let participantsVC = TripParticipantsViewController()
        participantsVC.currentUser = user
        vc.navigationController?.pushViewController(participantsVC, animated: true)
    }
}
