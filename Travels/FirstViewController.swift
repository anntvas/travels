//
//  FirstViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import Foundation
import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TripCell.self, forCellReuseIdentifier: TripCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Properties
    private var trips: [Trip] = []
    private var currentUser: User?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        loadCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTrips()
    }
    private func setupNavigationBar() {
            let addButton = UIBarButtonItem(
                image: UIImage(systemName: "plus"),
                style: .plain,
                target: self,
                action: #selector(createTripTapped)
            )
            addButton.tintColor = UIColor(hex: "#FFDD2D")
            navigationItem.rightBarButtonItem = addButton
            
            // Опционально: Устанавливаем заголовок
            navigationItem.title = "Мои поездки"
    }
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Мои поездки"
        
        [tableView, emptyStateView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Data Management
    private func loadCurrentUser() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUserId"),
              let uuid = UUID(uuidString: userId) else { return }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            currentUser = try DataController.shared.context.fetch(request).first
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    private func fetchTrips() {
        guard let user = currentUser else { return }
        
        trips = Trip.fetchTrips(for: user, in: DataController.shared.context)
        emptyStateView.isHidden = !trips.isEmpty
        tableView.reloadData()
    }
    
    
    private func showTripForm(trip: Trip? = nil) {
        let isEditing = trip != nil
        let alert = UIAlertController(
            title: isEditing ? "Редактировать поездку" : "Новая поездка",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Название"
            textField.text = trip?.title
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Место назначения"
            textField.text = trip?.destination
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: isEditing ? "Сохранить" : "Создать", style: .default) { [weak self] _ in
            guard let self = self,
                  let title = alert.textFields?[0].text, !title.isEmpty,
                  let destination = alert.textFields?[1].text, !destination.isEmpty else {
                self?.showAlert(title: "Ошибка", message: "Заполните все поля")
                return
            }
            
            if let trip = trip {
                // Редактирование существующей поездки
                trip.update(title: title, destination: destination)
            } else {
                // Создание новой поездки
                Trip.create(
                    title: title,
                    destination: destination,
                    startDate: Date(),
                    endDate: Date().addingTimeInterval(86400 * 7), // +7 дней
                    user: self.currentUser!,
                    in: DataController.shared.context
                )
            }
            
            self.fetchTrips()
        })
        
        present(alert, animated: true)
    }
    // Анимация при нажатии
    @objc private func createTripTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.navigationItem.rightBarButtonItem?.customView?.transform = .identity
            }
            self.showTripForm()
        }
    }

    // Или добавить badge для новых уведомлений
    func updateAddButton(withBadge: Bool) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(hex: "#FFDD2D")
        button.addTarget(self, action: #selector(createTripTapped), for: .touchUpInside)
        
        if withBadge {
            let badge = UIView()
            badge.backgroundColor = .red
            badge.layer.cornerRadius = 4
            button.addSubview(badge)
            
            badge.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                badge.widthAnchor.constraint(equalToConstant: 8),
                badge.heightAnchor.constraint(equalToConstant: 8),
                badge.topAnchor.constraint(equalTo: button.topAnchor, constant: 2),
                badge.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -2)
            ])
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}

// MARK: - UITableView DataSource & Delegate
extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TripCell.identifier, for: indexPath) as! TripCell
        cell.configure(with: trips[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showTripForm(trip: trips[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            trips[indexPath.row].delete()
            trips.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            emptyStateView.isHidden = !trips.isEmpty
        }
    }
}

// MARK: - Trip Cell
class TripCell: UITableViewCell {
    static let identifier = "TripCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, destinationLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with trip: Trip) {
        titleLabel.text = trip.title
        destinationLabel.text = trip.destination
    }
}

// MARK: - Empty State View
class EmptyStateView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Нет поездок"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FirstViewController {
    func showAlert(
        title: String = "Ошибка",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction]? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        // Если действия не переданы - добавляем стандартную кнопку "OK"
        if let actions = actions {
            actions.forEach { alert.addAction($0) }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        // Для iPad (если используется .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
}
