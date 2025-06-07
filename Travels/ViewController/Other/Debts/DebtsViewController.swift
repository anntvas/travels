//
//  DebtsViewController.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import UIKit

final class DebtsViewController: UIViewController, DebtsViewProtocol {
    var presenter: DebtsPresenterProtocol?
    
    private var debts: [String] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Долги"
        view.backgroundColor = .systemBackground
        setupTableView()
        presenter?.onViewDidLoad()
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

    // MARK: - DebtsViewProtocol
    func showDebts(_ debts: [String]) {
        self.debts = debts
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension DebtsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebtCell", for: indexPath)
        cell.textLabel?.text = debts[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return cell
    }
}
