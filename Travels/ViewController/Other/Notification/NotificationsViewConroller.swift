//
//  NotificationViewConroller.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import UIKit


final class NotificationsViewController: UIViewController, NotificationsViewProtocol {
    var presenter: NotificationsPresenterProtocol?
    
    private var notifications: [String] = []
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let clearButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Уведомления"
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Настройка таблицы
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Настройка кнопки
        clearButton.setTitle("Очистить уведомления", for: .normal)
        clearButton.setTitleColor(.systemBlue, for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        clearButton.backgroundColor = .systemGray6
        clearButton.layer.cornerRadius = 12
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            clearButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            clearButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc private func clearButtonTapped() {
        presenter?.didTapClearButton()
    }
    
    // MARK: - NotificationsViewProtocol
    func displayNotifications(_ notifications: [String]) {
        self.notifications = notifications
        tableView.reloadData()
        showClearButton(enabled: !notifications.isEmpty)
    }
    
    func showEmptyState() {
        // Реализация пустого состояния
    }
    
    func showClearButton(enabled: Bool) {
        clearButton.isEnabled = enabled
        clearButton.alpha = enabled ? 1.0 : 0.5
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
        showClearButton(enabled: !notifications.isEmpty)
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configure(text: notifications[indexPath.row])
        cell.onDelete = { [weak self] in
            self?.presenter?.didTapDelete(at: indexPath.row)
        }
        return cell
    }
}
