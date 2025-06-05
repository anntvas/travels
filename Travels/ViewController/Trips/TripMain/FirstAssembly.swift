//
//  FirstAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

enum FirstAssembly {
    static func build() -> UIViewController {
        let model = FirstModel()
        let router = FirstRouter()
        let presenter: FirstPresenterProtocol = FirstPresenter(model: model, router: router)
        let vc = FirstViewController(presenter: presenter)
        presenter.attachView(vc)
        router.setViewController(vc)
        return vc
    }

}
