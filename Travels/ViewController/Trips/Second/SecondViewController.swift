//
//  SecondViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit

final class SecondViewController: UIViewController, SecondViewProtocol, TripTableViewCellDelegate {
    
    var presenter: SecondPresenterProtocol?
    
    private let tableView = UITableView()
    private var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        // Register only TripTableViewCell
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: "TripTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Поездки"
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTripTapped))
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 92
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Remove TripCell registration
        // tableView.register(TripCell.self, forCellReuseIdentifier: TripCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func addTripTapped() {
        presenter?.addTripTapped()
    }
    
    // MARK: - SecondViewProtocol
    func displayTrips(_ trips: [Trip]) {
        self.trips = trips
        tableView.reloadData()
    }
    
    func tripCellDidTapAccept(_ cell: TripTableViewCell) {
        presenter?.confirmTrip(tripId: cell.tripId!)
    }

    func tripCellDidTapDecline(_ cell: TripTableViewCell) {
        presenter?.cancelTrip(tripId: cell.tripId!)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell", for: indexPath) as? TripTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self

        // You need to map Trip to TripPreview, or adapt TripTableViewCell to accept Trip directly.
        // Example mapping (you must implement this mapping based on your models):
        let preview = TripPreview(
            id: Int(trip.id),
            title: trip.title ?? "Без названия",
            subtitle: "\(trip.departureCity ?? "") → \(trip.destinationCity ?? "")",
            avatar: .initial(String(trip.title?.first ?? "T")),
            status: trip.status // Set this based on your model
        )
        cell.configure(with: preview)
        // If you want to show/hide buttons, set cell.actionStack.isHidden as needed

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectTrip(trips[indexPath.row])
    }
    
}


