//
//  MainTabBarAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

enum MainTabBarAssembly {
    static func build() -> UITabBarController {
        let tabBarVC = MainTabBarController()
        
        // Первый таб
        let firstVC = FirstAssembly.build()
        firstVC.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Второй таб (история поездок)
        let secondVC = SecondAssembly.build()
        secondVC.tabBarItem = UITabBarItem(
            title: "История",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            selectedImage: nil
        )
        
        let thirdVC = ThirdAssembly.build()
        thirdVC.tabBarItem = UITabBarItem(
            title: "Ещё",
            image: UIImage(systemName: "person.fill"),
            selectedImage: nil
        )
        
        tabBarVC.viewControllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC),
            UINavigationController(rootViewController: thirdVC)
        ]
        
        return tabBarVC
    }
}
