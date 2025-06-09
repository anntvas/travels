//
//  ProfileAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

enum ProfileAssembly {
    static func build() -> UIViewController {
        let view = ProfileViewController()
        let model = ProfileModel()
        let router = ProfileRouter()
        let presenter = ProfilePresenter(view: view, model: model, router: router)
        view.presenter = presenter
        router.viewController = view
        return view
    }
}
