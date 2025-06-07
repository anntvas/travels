//
//  SecondBuilder.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import UIKit

enum SecondAssembly {
    static func build() -> UIViewController {
        let view = SecondViewController()
        let model = SecondModel()
        let router = SecondRouter(viewController: view)
        let presenter = SecondPresenter(model: model, router: router)
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
