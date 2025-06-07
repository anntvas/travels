//
//  BudgetAllocationViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit

class BudgetAllocationViewController: UIViewController {

    var currentUser: User!
    private var categories: [BudgetCategoryModel] = TripCreationManager.shared.categories
    private let totalBudget: Double = TripCreationManager.shared.totalBudget

    private let tableView = UITableView()
    private let nextButton = UIButton(type: .system)
    private let totalLabel = UILabel()
    private let remainingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Распределение бюджета"
        setupUI()
        setupTableView()
        updateTotalLabels()
    }

    private func setupUI() {
        totalLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false

        remainingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        remainingLabel.textAlignment = .center
        remainingLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag

        nextButton.setTitle("Подтвердить создание поездки", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(totalLabel)
        view.addSubview(remainingLabel)
        view.addSubview(tableView)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            remainingLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 5),
            remainingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            remainingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: remainingLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),

            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BudgetCategoryCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.rowHeight = 60
    }

    private func updateTotalLabels() {
        let allocated = categories.reduce(0) { $0 + $1.allocatedAmount }
        totalLabel.text = "Общий бюджет: \(totalBudget.formattedWithSeparator) ₽"

        let remaining = totalBudget - allocated
        remainingLabel.text = "Остаток: \(remaining.formattedWithSeparator) ₽"
        remainingLabel.textColor = remaining < 0 ? .systemRed : .systemGreen
    }

    @objc private func nextTapped() {
        let allocated = categories.reduce(0) { $0 + $1.allocatedAmount }

        guard allocated > 0 else {
            showAlert(title: "Ошибка", message: "Распределите бюджет по категориям")
            return
        }

        guard abs(allocated - totalBudget) < 0.01 else {
            showAlert(title: "Ошибка", message: "Сумма по категориям (\(allocated.formattedWithSeparator) ₽) должна равняться общему бюджету (\(totalBudget.formattedWithSeparator) ₽)")
            return
        }

        TripCreationManager.shared.categories = categories
        let newTrip = TripCreationManager.shared.createTrip(in: DataController.shared.context)
            
            do {
                try DataController.shared.context.save()
                
                // Затем синхронизируем с сервером
                TripCreationManager.shared.syncTrip { success in
                    if success {
                        self.dismissAndNotify()
                    } else {
                        self.showSyncError()
                    }
                }
            } catch {
                print("Ошибка сохранения: \(error)")
            }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func dismissAndNotify() {
        TripCreationManager.shared.reset()
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("TripCreated"), object: nil)
        }
    }

    private func showSyncError() {
        showAlert(
            title: "Ошибка синхронизации",
            message: "Данные сохранены локально, но не синхронизированы с сервером"
        )
    }
}

extension BudgetAllocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? BudgetCategoryCell else {
            return UITableViewCell()
        }

        let category = categories[indexPath.row]
        cell.configure(with: category, totalBudget: totalBudget)

        cell.onAmountChanged = { [weak self] amount in
            self?.categories[indexPath.row].allocatedAmount = amount
            self?.updateTotalLabels()
        }

        return cell
    }
}

