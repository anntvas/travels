//
//  AddExpenseAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

enum AddExpenseAssembly {
    static func build(tripId: Int) -> UIViewController {
        let viewController = AddExpenseViewController()
        let model = AddExpenseModel(tripId: tripId)
        let presenter = AddExpensePresenter(view: viewController, model: model)
        viewController.presenter = presenter
        return viewController
    }

}
