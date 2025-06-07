//
//  HistoryViewController.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import UIKit

final class HistoryViewController: UIViewController, HistoryViewProtocol {
    var presenter: HistoryPresenterProtocol?

    private var historyItems: [String] = []
    private let tableView = UITableView()
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить историю", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "История"
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.onViewDidLoad()
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(clearButton)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.separatorStyle = .singleLine

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            clearButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            clearButton.widthAnchor.constraint(equalToConstant: 200)
        ])

        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }

    @objc private func clearButtonTapped() {
        presenter?.clearHistory()
    }

    // MARK: - HistoryViewProtocol
    func showHistory(_ items: [String]) {
        self.historyItems = items
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = "Annna"
//        cell.textLabel?.text = historyItems[indexPath.row]
        return cell
    }
}
