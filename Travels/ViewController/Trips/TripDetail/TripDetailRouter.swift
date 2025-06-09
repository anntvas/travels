//
//  TripDetailRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

protocol TripDetailRouterProtocol: AnyObject {
    func navigateToAddExpense(tripId: Int)
}

final class TripDetailRouter: TripDetailRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToAddExpense(tripId: Int) {
        let addExpenseVC = AddExpenseAssembly.build(tripId: tripId)
        viewController?.navigationController?.pushViewController(addExpenseVC, animated: true)
    }
}
