//
//  MainTabBarController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit

final class MainTabBarController: UITabBarController, MainTabBarViewProtocol {
    var presenter: MainTabBarPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: - MainTabBarViewProtocol
    func setupViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    func setupTabBarAppearance(tintColor: UIColor, unselectedColor: UIColor) {
        tabBar.tintColor = tintColor
        tabBar.unselectedItemTintColor = unselectedColor
    }
}
