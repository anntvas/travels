//
//  FirstAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

enum FirstAssembly {
    static func build() -> UIViewController {
        let view = FirstViewController()
        let model = FirstModel()
        let router = FirstRouter(viewController: view)
        let presenter = FirstPresenter(model: model, router: router)
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
