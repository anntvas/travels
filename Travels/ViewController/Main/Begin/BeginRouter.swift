//
//  BeginRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit
protocol BeginRouterProtocol {
    func navigateToAuth()
}

final class BeginRouter: BeginRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateToAuth() {
        let authVC = AuthAssembly.build()
        viewController?.navigationController?.pushViewController(authVC, animated: true)
    }
}
