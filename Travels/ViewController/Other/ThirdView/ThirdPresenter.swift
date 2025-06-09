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
    func logoutTapped()
}

final class ThirdPresenter: ThirdPresenterProtocol {
    weak var view: ThirdViewProtocol?
    private let router: ThirdRouterProtocol
    
    private let menuItems: [MenuItem] = [
        MenuItem(title: "Профиль", icon: "person.circle", build: ProfileAssembly.build),
        MenuItem(title: "История", icon: "clock.arrow.circlepath", build: HistoryAssembly.build),
        MenuItem(title: "Уведомления", icon: "bell", build: NotificationsAssembly.build),
        MenuItem(title: "Долги", icon: "banknote", build: DebtsAssembly.build)
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
    
    func logoutTapped() {
        NetworkManager.shared.logout { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    UserDefaults.standard.removeObject(forKey: "currentUserId")
                    self?.router.changeRootToLogin()
                case .failure(let error):
                    print("Logout error: \(error)")
                }
            }
        }
    }

    
    func didSelectItem(at section: Int) {
        router.navigateTo(menuItems[section].build())
    }

}
