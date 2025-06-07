//
//  TripBudgetConfirmViewController.swift
//  Travels
//
//  Created by Anna on 29.05.2025.
//

import UIKit

final class TripBudgetConfirmViewController: UIViewController, TripBudgetConfirmViewProtocol {
    var presenter: TripBudgetConfirmPresenterProtocol!
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Подтверждение"
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = 100 // Для последующего обновления
        
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
        presenter.didTapConfirmButton()
    }
    
    // MARK: - TripBudgetConfirmViewProtocol
    func displayBudget(_ budget: Double) {
        if let label = view.viewWithTag(100) as? UILabel {
            label.text = "Вы установили бюджет: \(budget.formattedWithSeparator) ₽"
        }
    }
}
