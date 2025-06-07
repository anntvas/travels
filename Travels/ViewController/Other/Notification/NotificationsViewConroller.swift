//
//  NotificationViewConroller.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import Foundation
import UIKit

class NotificationsViewController: UIViewController {
    
    private var notifications: [String] = [
        "У вас есть долг",
        "Дима за вас заплатил"
    ]
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить уведомления", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Уведомления"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupClearButton()
    }
    
    private func setupTableView() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupClearButton() {
        clearButton.addTarget(self, action: #selector(clearAllNotifications), for: .touchUpInside)
        
        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            clearButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    @objc private func clearAllNotifications() {
        notifications.removeAll()
        tableView.reloadData()
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
            self?.notifications.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
}

// MARK: - Custom Cell
class NotificationCell: UITableViewCell {
    
    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    var onDelete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        messageLabel.text = text
    }
    
    private func setupViews() {
        iconView.image = UIImage(systemName: "exclamationmark.circle")?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .systemBlue
        
        messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        messageLabel.textColor = .label
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .darkGray
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        contentView.addSubview(iconView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(deleteButton)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -8),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}
