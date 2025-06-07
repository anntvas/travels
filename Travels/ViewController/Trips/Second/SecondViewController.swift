//
//  SecondViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit
import CoreData
import Moya

class SecondViewController: UIViewController {

    private let tableView = UITableView()
    private var trips: [Trip] = []
    private var currentUser: User!

    private var context: NSManagedObjectContext {
        return DataController.shared.context
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Поездки"
        setupNavigationBar()
        setupTableView()
        loadCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTrips()
    }

    private func loadCurrentUser() {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else { return }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(userId))

        do {
            currentUser = try context.fetch(request).first
        } catch {
            print("Ошибка загрузки пользователя: \(error)")
        }
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
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

    private func fetchTrips() {
        NetworkManager.shared.getTrips { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let networkTrips):
                self.processNetworkTrips(networkTrips: networkTrips)
                
            case .failure(let error):
                print("Ошибка загрузки поездок: \(error)")
                self.loadLocalTrips()
            }
        }
    }
    
    private func loadLocalTrips() {
        guard let currentUser = currentUser else {
            trips = []
            tableView.reloadData()
            return
        }
        
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.predicate = NSPredicate(format: "createdBy == %lld", currentUser.id)
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            trips = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Ошибка загрузки локальных поездок: \(error)")
            trips = []
            tableView.reloadData()
        }
    }
    
    private func processNetworkTrips(networkTrips: [TripResponse]) {
        // Удаляем старые поездки пользователя
        if let currentUser = currentUser {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Trip.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "createdBy == %lld", 1)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
            } catch {
                print("Ошибка удаления старых поездок: \(error)")
            }
        }
        
        // Сохраняем новые поездки
        for tripResponse in networkTrips {
            let trip = Trip(context: context)
            trip.id = Int64(tripResponse.id)
            trip.title = tripResponse.title
            trip.departureCity = tripResponse.departureCity
            trip.destinationCity = tripResponse.destinationCity
            trip.startDate = dateFromString(tripResponse.startDate)
            trip.endDate = dateFromString(tripResponse.endDate)
            
            // Связываем поездку с текущим пользователем
            if let currentUser = currentUser {
                trip.createdBy = currentUser.id
            }
        }
        
        do {
            try context.save()
            loadLocalTrips()
        } catch {
            print("Ошибка сохранения сетевых поездок: \(error)")
            loadLocalTrips()
        }
    }

    @objc private func addTripTapped() {
//        let tripVC = TripDetailsViewController()
//        
//        if let user = currentUser {
//            tripVC.currentUser = user
//        }
//        
//        let nav = UINavigationController(rootViewController: tripVC)
//        present(nav, animated: true)
    }
    func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Укажи нужный формат
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
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
        let selectedTrip = trips[indexPath.row]
        let detailVC = TripDetailViewController()
        detailVC.configure(with: selectedTrip)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
