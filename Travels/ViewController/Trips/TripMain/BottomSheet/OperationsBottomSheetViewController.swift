//
//  OperationsViewController.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//
import UIKit

class OperationsBottomSheetViewController: BottomSheetViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private var expenses: [ExpenseResponse] = []
    var tripId: Int = 24 // Set this before presenting

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchExpenses()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        sheetView.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -16)
        ])
    }

    private func fetchExpenses() {
        NetworkManager.shared.getMyExpenses(tripId: tripId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let expenses):
                    self?.expenses = expenses
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch expenses: \(error)")
                }
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        cell.textLabel?.text = "\(expense.description): \(expense.amount) ₽"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}
        
