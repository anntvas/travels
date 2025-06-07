//
//  FileBudgetCategoriesViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit
import CoreData

class BudgetCategoriesViewController: UIViewController {

    var currentUser: User!

    private let categories = [
        "Билеты", "Отели", "Питание", "Развлечения",
        "Страховка", "Транспорт", "Подарки", "Другое"
    ]

    private var selectedCategories: [BudgetCategoryModel] = []

    private let tableView = UITableView()
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Категории бюджета"

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        nextButton.setTitle("Распределить бюджет", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.allowsMultipleSelection = true
    }

    @objc private func nextTapped() {
        guard !selectedCategories.isEmpty else {
            showAlert(message: "Выберите хотя бы одну категорию")
            return
        }

        TripCreationManager.shared.categories = selectedCategories

        let allocationVC = BudgetAllocationViewController()
        allocationVC.currentUser = currentUser
        navigationController?.pushViewController(allocationVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BudgetCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]

        let isSelected = selectedCategories.contains { $0.category == categories[indexPath.row] }
        cell.accessoryType = isSelected ? .checkmark : .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryName = categories[indexPath.row]

        if let index = selectedCategories.firstIndex(where: { $0.category == categoryName }) {
            selectedCategories.remove(at: index)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            let newCategory = BudgetCategoryModel(category: categoryName, allocatedAmount: 0)
            selectedCategories.append(newCategory)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
