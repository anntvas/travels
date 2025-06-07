//
//  ExpenseDetailAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit
enum ExpenseDetailAssembly {
    static func build() -> UIViewController {
        let view = ExpenseDetailViewController()
        let model = ExpenseDetailModel()
        let presenter = ExpenseDetailPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
