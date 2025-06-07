//
//  AddExpenseAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit


enum AddExpenseAssembly {
    static func build() -> UIViewController {
        let view = AddExpenseViewController()
        let model = AddExpenseModel()
        let presenter = AddExpensePresenter(view: view, model: model)
        
        view.presenter = presenter
        return view
    }
}
