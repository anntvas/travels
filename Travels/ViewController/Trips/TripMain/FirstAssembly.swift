//
//  FirstAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

enum FirstAssembly {
    static func build() -> UIViewController {
        let view = FirstViewController()
        let model = FirstModel()
        let router = FirstRouter()
        let presenter = FirstPresenter(view: view, model: model, router: router)
        view.inject(presenter: presenter)
        router.viewController = view
        return view
    }
}
