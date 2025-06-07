//
//  ThirdPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
protocol ThirdViewProtocol: AnyObject {
    func reloadData()
}
protocol ThirdPresenterProtocol: AnyObject {
    var numberOfSections: Int { get }
    func itemForSection(_ section: Int) -> MenuItem
    func didSelectItem(at section: Int)
}

final class ThirdPresenter: ThirdPresenterProtocol {
    weak var view: ThirdViewProtocol?
    private let router: ThirdRouterProtocol
    
    private let menuItems: [MenuItem] = [
        MenuItem(title: "Профиль", icon: "person.circle", controller: ProfileViewController.self),
        MenuItem(title: "История", icon: "clock.arrow.circlepath", controller: HistoryViewController.self),
        MenuItem(title: "Уведомления", icon: "bell", controller: NotificationsViewController.self),
        MenuItem(title: "Долги", icon: "banknote", controller: DebtsViewController.self)
    ]
    
    init(router: ThirdRouterProtocol) {
        self.router = router
    }
    
    var numberOfSections: Int {
        return menuItems.count
    }
    
    func itemForSection(_ section: Int) -> MenuItem {
        return menuItems[section]
    }
    
    func didSelectItem(at section: Int) {
        router.navigateTo(menuItems[section].controller)
    }
}
