//
//  ParticipantsBottomSheetViewController.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

final class ParticipantsBottomSheetViewController: BottomSheetViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private var participants: [ParticipantResponse] = []
    var tripId: Int = 24

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchParticipants()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(ParticipantCell.self, forCellReuseIdentifier: "ParticipantCell")
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

    private func fetchParticipants() {
        NetworkManager.shared.listParticipants(tripId: tripId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let participants):
                    self?.participants = participants
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch participants: \(error)")
                }
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        participants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as? ParticipantCell else {
            return UITableViewCell()
        }
        let participant = participants[indexPath.row]
        cell.configure(with: participant)
        return cell
    }
}
