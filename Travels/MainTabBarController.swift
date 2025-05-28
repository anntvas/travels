//
//  MainTabBarController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        // Главная
        let firstVC = FirstViewController()
        firstVC.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Поиск
        let secondVC = SecondViewController()
        secondVC.tabBarItem = UITabBarItem(
            title: "История",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            selectedImage: nil
        )
        
        // Профиль
        let thirdVC = ThirdViewController()
        thirdVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC),
            UINavigationController(rootViewController: thirdVC)
        ]
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
    }
}
