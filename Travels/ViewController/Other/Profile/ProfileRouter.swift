//
//  ProfileRouter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import UIKit

protocol ProfileRouterProtocol: AnyObject {
    func navigateToEditAccount()
}

final class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToEditAccount() {
        let editAccountVC = EditAccountAssembly.build() // Замените на ваш модуль
        viewController?.navigationController?.pushViewController(editAccountVC, animated: true)
    }
}
