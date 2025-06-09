//
//  MyDebtsViewController.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

class ReceivableBottomSheetViewController: BottomSheetViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private var settlements: [SettlementItem] = []
    var tripId: Int = 24 // Set this before presenting

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchReceivableSettlements()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReceivableCell")
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

    private func fetchReceivableSettlements() {
        NetworkManager.shared.getSettlementsReceivable(tripId: tripId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let settlements):
                    self?.settlements = settlements
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch receivable settlements: \(error)")
                }
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settlements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivableCell", for: indexPath)
        let item = settlements[indexPath.row]
        cell.textLabel?.text = "From \(item.from) to \(item.to): \(item.amount) ₽ (\(item.status.rawValue))"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}
