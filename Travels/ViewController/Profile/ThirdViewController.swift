//
//  ThirdViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit

class ThirdViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let menuItems: [(title: String, icon: String, controller: UIViewController.Type)] = [
        ("Профиль", "person.circle", ProfileViewController.self),
        ("История", "clock.arrow.circlepath", HistoryViewController.self),
        ("Уведомления", "bell", NotificationsViewController.self),
        ("Долги", "banknote", DebtsViewController.self)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ещё"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ThirdViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (title, icon, _) = menuItems[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.configure(title: title, iconName: icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, _, controllerType) = menuItems[indexPath.section]
        let vc = controllerType.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
