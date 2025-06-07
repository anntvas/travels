//
//  MainTabBarPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import UIKit
protocol MainTabBarViewProtocol: AnyObject {
    func setupViewControllers(_ viewControllers: [UIViewController])
    func setupTabBarAppearance(tintColor: UIColor, unselectedColor: UIColor)
}
protocol MainTabBarPresenterProtocol {
    func viewDidLoad()
}
final class MainTabBarPresenter: MainTabBarPresenterProtocol {
    private weak var view: MainTabBarViewProtocol?
    private let router: MainTabBarRouterProtocol
    
    init(view: MainTabBarViewProtocol, router: MainTabBarRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        let firstVC = router.createFirstViewController()
        firstVC.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let secondVC = router.createSecondViewController()
        secondVC.tabBarItem = UITabBarItem(
            title: "История",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            selectedImage: nil
        )
        
        let thirdVC = router.createThirdViewController()
        thirdVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        let controllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC),
            UINavigationController(rootViewController: thirdVC)
        ]
        
        view?.setupViewControllers(controllers)
        view?.setupTabBarAppearance(tintColor: .systemBlue, unselectedColor: .gray)
    }
}
