//
//  ThirdRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import UIKit
protocol ThirdRouterProtocol {
    func navigateTo(_ build: @autoclosure () -> UIViewController)
    func navigateToRoot()
    func changeRootToLogin()
}

final class ThirdRouter: ThirdRouterProtocol {
    weak var viewController: UIViewController?

    func navigateTo(_ build: @autoclosure () -> UIViewController) {
        let vc = build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRoot() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
    
    func changeRootToLogin() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginVC = UINavigationController(rootViewController: BeginAssembly.build())
            sceneDelegate.changeRootViewController(to: loginVC)
        }
    }

}
