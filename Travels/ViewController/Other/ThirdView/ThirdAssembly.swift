//
//  ThirdAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

enum ThirdAssembly {
    static func build() -> UIViewController {
        let view = ThirdViewController()
        let router = ThirdRouter()
        let presenter = ThirdPresenter(router: router)
        
        view.presenter = presenter
        presenter.view = view
        router.viewController = view
        
        return view
    }
}
