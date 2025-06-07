//
//  ThirdRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import UIKit
protocol ThirdRouterProtocol {
    func navigateTo(_ controller: UIViewController.Type)
}
final class ThirdRouter: ThirdRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateTo(_ controller: UIViewController.Type) {
        let vc = controller.init()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
