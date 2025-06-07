//
//  AuthAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

enum AuthAssembly {
    static func build() -> UIViewController {
        let view = AuthViewController()
        let model = AuthModel()
        let router = AuthRouter(viewController: view)
        let presenter = AuthPresenter(view: view, model: model, router: router)
        
        view.presenter = presenter
        return view
    }
}

