//
//  MainTabBarRouter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

protocol MainTabBarRouterProtocol {
    func createFirstViewController() -> UIViewController
    func createSecondViewController() -> UIViewController
    func createThirdViewController() -> UIViewController
}

final class MainTabBarRouter: MainTabBarRouterProtocol {
    func createFirstViewController() -> UIViewController {
        return FirstAssembly.build()
    }
    
    func createSecondViewController() -> UIViewController {
        return SecondAssembly.build()
    }
    
    func createThirdViewController() -> UIViewController {
        return ThirdAssembly.build()
    }
}
