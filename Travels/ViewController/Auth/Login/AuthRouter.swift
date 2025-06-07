//
//  AuthRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit
protocol AuthRouterProtocol {
    func navigateToMainScreen()
    func navigateToRegister()
}
// AuthRouter.swift
final class AuthRouter: AuthRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateToMainScreen() {
        let tabBarVC = MainTabBarAssembly.build()
        
        guard let window = viewController?.view.window else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = tabBarVC
        }, completion: nil)
    }
    
    func navigateToRegister() {
        let registerVC = RegisterAssembly.build()
        viewController?.navigationController?.pushViewController(registerVC, animated: true)
    }
}
