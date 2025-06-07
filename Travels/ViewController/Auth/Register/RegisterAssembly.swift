//
//  RegisterAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

enum RegisterAssembly {
    static func build() -> UIViewController {
        let view = RegisterViewController()
        let model = RegisterModel()
        let router = RegisterRouter(viewController: view)
        let presenter = RegisterPresenter(view: view, model: model, router: router)
        
        view.presenter = presenter
        return view
    }
}
