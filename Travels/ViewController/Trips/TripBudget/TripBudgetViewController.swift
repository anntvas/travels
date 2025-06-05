//
//  TripBudgetViewController.swift
//  Travels
//
//  Created by Anna on 29.05.2025.
//
import UIKit

final class TripBudgetViewController: UIViewController, TripBudgetViewProtocol {
    
    private let presenter: TripBudgetPresenter

    init(presenter: TripBudgetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private let budgetField = UITextField()
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Бюджет"
        setupUI()

        if TripCreationManager.shared.totalBudget > 0 {
            budgetField.text = String(TripCreationManager.shared.totalBudget)
        }
    }

    private func setupUI() {
        budgetField.placeholder = "Введите бюджет (₽)"
        budgetField.keyboardType = .decimalPad
        budgetField.borderStyle = .roundedRect
        budgetField.translatesAutoresizingMaskIntoConstraints = false

        nextButton.setTitle("Далее", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(budgetField)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            budgetField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            budgetField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            budgetField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nextButton.topAnchor.constraint(equalTo: budgetField.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func nextTapped() {
        presenter.nextTapped(with: budgetField.text)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
