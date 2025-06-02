//
//  DebtsViewController.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import Foundation
import UIKit

class DebtsViewController: UIViewController {
    
    private let debts: [String] = [
        "Вы должны Ане 500 ₽",
        "Дима должен вам 800 ₽"
    ]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Долги"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DebtCell")
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DebtsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = debts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebtCell", for: indexPath)
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return cell
    }
}
