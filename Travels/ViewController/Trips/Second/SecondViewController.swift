//
//  SecondViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit

final class SecondViewController: UIViewController, SecondViewProtocol {
    var presenter: SecondPresenterProtocol?
    
    private let tableView = UITableView()
    private var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
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
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripCell")
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
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = trip.title ?? "Без названия"
        content.secondaryText = "\(trip.departureCity ?? "") → \(trip.destinationCity ?? "")"
        
        if let startDate = trip.startDate,
           let endDate = trip.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            content.secondaryText?.append("\n\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))")
        }
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectTrip(trips[indexPath.row])
    }
}
