//
//  ExpenseDetailViewController.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import Foundation
import UIKit

class ExpenseDetailViewController: UIViewController {

    private let tableView = UITableView()
    private var expenses: [(name: String, amount: Int, category: String, time: String, isCurrentUser: Bool, date: String?)] = [
        ("Вы", -52000, "Отель", "11:11", true, nil),
        ("Олег", -2000, "Питание", "20:33", false, nil),
        ("Анастасия", -2000, "Питание", "20:33", false, "31 марта")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Это Питер, детка!"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpense))

        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExpenseMessageCell.self, forCellReuseIdentifier: "ExpenseMessageCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func addExpense() {
        // Добавление нового расхода — открой экран добавления
    }
}

extension ExpenseDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenses.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = expenses[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseMessageCell", for: indexPath) as! ExpenseMessageCell
        cell.configure(name: expense.name, amount: expense.amount, category: expense.category, time: expense.time, isCurrentUser: expense.isCurrentUser)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return expenses[section].date
    }
}

class ExpenseMessageCell: UITableViewCell {

    private let bubbleView = UIView()
    private let nameLabel = UILabel()
    private let amountLabel = UILabel()
    private let categoryLabel = UILabel()
    private let timeLabel = UILabel()

    func configure(name: String, amount: Int, category: String, time: String, isCurrentUser: Bool) {
        bubbleView.backgroundColor = isCurrentUser ? UIColor.systemBlue : UIColor(white: 0.95, alpha: 1)
        bubbleView.layer.cornerRadius = 16

        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = isCurrentUser ? .white : .black

        amountLabel.text = "\(amount) ₽"
        amountLabel.font = .boldSystemFont(ofSize: 22)
        amountLabel.textColor = isCurrentUser ? .white : .black

        categoryLabel.text = category
        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = isCurrentUser ? .white : .gray

        timeLabel.text = time
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = isCurrentUser ? .white : .gray
        timeLabel.textAlignment = .right

        layoutUI(isCurrentUser: isCurrentUser)
    }

    private func layoutUI(isCurrentUser: Bool) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        bubbleView.subviews.forEach { $0.removeFromSuperview() }

        let stack = UIStackView(arrangedSubviews: [nameLabel, amountLabel, categoryLabel, timeLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16)
        ])

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        if isCurrentUser {
            NSLayoutConstraint.activate([
                bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
            ])
        } else {
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
            ])
        }
    }
}

