//
//  HistoryViewController.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController {
    
    private let history: [String] = [
        "Поездка в Сочи 12–18 мая",
        "Поездка в Казань 1–4 апреля",
        "Поездка в Стамбул 21–27 февраля"
    ]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "История"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
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

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = history[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return cell
    }
}
