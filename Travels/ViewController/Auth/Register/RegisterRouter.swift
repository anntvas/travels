//
//  RegisterRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

protocol RegisterRouterProtocol {
    func navigateBackToAuth()
}

final class RegisterRouter: RegisterRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateBackToAuth() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
