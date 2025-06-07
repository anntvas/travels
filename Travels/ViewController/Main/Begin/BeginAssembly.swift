//
//  BeginAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit
enum BeginAssembly {
    static func build() -> UIViewController {
        let view = BeginViewController()
        let router = BeginRouter(viewController: view)
        let presenter = BeginPresenter(view: view, router: router)
        
        view.presenter = presenter
        return view
    }
}
