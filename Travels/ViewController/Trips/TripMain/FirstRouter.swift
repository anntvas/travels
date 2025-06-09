//
//  FirstRouter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

protocol FirstRouterProtocol {
    func openCreateTrip()
    func showOperations(for trip: Trip?)
    func showParticipants(for trip: Trip?)
    func showBudget(for trip: Trip?)
    func showMyExpenses(for trip: Trip?)
    func showMyDebts(for trip: Trip?)
    func showOwedToMe(for trip: Trip?)

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
        let sheet = ParticipantsBottomSheetViewController()
        sheet.tripId = Int(trip?.id ?? 24)
        sheet.modalPresentationStyle = .overFullScreen
        viewController?.present(sheet, animated: true)
    }

    func showOperations(for trip: Trip?) {
        let sheet = OperationsBottomSheetViewController()
        sheet.tripId = Int(trip?.id ?? 24)
        sheet.modalPresentationStyle = .overFullScreen
        viewController?.present(sheet, animated: true)
    }
    
    func showBudget(for trip: Trip?) {
//        let sheet = BottomSheetViewController()
//        sheet.modalPresentationStyle = .overFullScreen
//        viewController?.present(sheet, animated: false)
    }
    
    func showMyExpenses(for trip: Trip?) {
//        let sheet = BottomSheetViewController()
//        sheet.modalPresentationStyle = .overFullScreen
//        viewController?.present(sheet, animated: false)
    }
    
    func showMyDebts(for trip: Trip?) {
        let sheet = PayableBottomSheetViewController()
        sheet.tripId = Int(trip?.id ?? 24)
        sheet.modalPresentationStyle = .overFullScreen
        viewController?.present(sheet, animated: false)
    }
    
    func showOwedToMe(for trip: Trip?) {
        let sheet = ReceivableBottomSheetViewController()
        sheet.tripId = Int(trip?.id ?? 24)
        sheet.modalPresentationStyle = .overFullScreen
        viewController?.present(sheet, animated: false)
    }
    
}
