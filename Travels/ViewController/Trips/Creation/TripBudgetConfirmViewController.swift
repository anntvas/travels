//
//  TripBudgetConfirmViewController.swift
//  Travels
//
//  Created by Anna on 29.05.2025.
//

import UIKit
import CoreData

class TripBudgetConfirmViewController: UIViewController {

    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Подтверждение"
        setupUI()
    }

    private func setupUI() {
        let label = UILabel()
        label.text = "Вы установили бюджет: \(TripCreationManager.shared.totalBudget.formattedWithSeparator) ₽"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Подтвердить и выбрать категории", for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            confirmButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func confirmTapped() {
        saveTripAndGoToCategories()
    }

    private func saveTripAndGoToCategories() {
        let categoriesVC = BudgetCategoriesViewController()
        categoriesVC.currentUser = currentUser
        navigationController?.pushViewController(categoriesVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
