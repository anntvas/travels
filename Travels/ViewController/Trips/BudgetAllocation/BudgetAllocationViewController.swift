//
//  BudgetAllocationViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit

final class BudgetAllocationViewController: UIViewController, BudgetAllocationViewProtocol {
    var presenter: BudgetAllocationPresenterProtocol!
    
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
        presenter.viewDidLoad()
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
    
    @objc private func nextTapped() {
        presenter.didTapNextButton()
    }
    
    // MARK: - BudgetAllocationViewProtocol
    func updateTotalLabels(total: String, remaining: String, remainingColor: UIColor) {
        totalLabel.text = total
        remainingLabel.text = remaining
        remainingLabel.textColor = remainingColor
    }
    
    func showValidationError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSyncSuccess() {
        let alert = UIAlertController(
            title: "Успешно",
            message: "Поездка создана",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.presenter?.reset()
            self?.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name("TripCreated"), object: nil)
            }
        })
        present(alert, animated: true)
    }
    
    func showSyncError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка синхронизации",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension BudgetAllocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "categoryCell",
            for: indexPath
        ) as? BudgetCategoryCell else {
            return UITableViewCell()
        }
        
        let category = presenter.category(at: indexPath.row)
        cell.configure(with: category, totalBudget: presenter.totalBudget)
        
        cell.onAmountChanged = { [weak self] amount in
            self?.presenter.didUpdateAmount(amount, forCategoryAt: indexPath.row)
        }
        
        return cell
    }
}
