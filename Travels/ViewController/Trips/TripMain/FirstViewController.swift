//
//  FirstViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//
//
//  FirstViewController.swift
//  Travels
//

import UIKit

final class FirstViewController: UIViewController, FirstViewProtocol {

    var presenter: FirstPresenterProtocol?

    private let titleButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private let placeholderLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    func displayTrips(current: Trip?, all: [Trip]) {
        updateUI(currentTrip: current)
    }

    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupStackView()
        setupPlaceholder()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createTripTapped))
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        titleButton.setTitleColor(.label, for: .normal)
        titleButton.addTarget(self, action: #selector(showTripSelector), for: .touchUpInside)
        stackView.addArrangedSubview(titleButton)
    }

    private func setupPlaceholder() {
        placeholderLabel.text = "У вас пока нет активных поездок"
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.isHidden = true
        stackView.addArrangedSubview(placeholderLabel)
    }

    private func updateUI(currentTrip: Trip?) {
        stackView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }

        let title = currentTrip?.title ?? "Нет активных поездок"
        titleButton.setTitle(title, for: .normal)

        guard let trip = currentTrip else {
            placeholderLabel.isHidden = false
            return
        }

        placeholderLabel.isHidden = true

        let budget = makeInfoCard(title: "Бюджет", amount: "\(Int(trip.budget?.totalBudget ?? 0)) ₽", iconName: "rublesign.circle.fill")
        let myExpenses = makeInfoCard(title: "Мои траты", amount: "100 ₽", iconName: "wallet.pass.fill")
        let myDebts = makeInfoCard(title: "Мои долги", amount: "0 ₽", iconName: "creditcard.fill")
        let owedToMe = makeInfoCard(title: "Мне должны", amount: "5000 ₽", iconName: "wallet.pass")

        [budget, myExpenses, myDebts, owedToMe].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func makeInfoCard(title: String, amount: String, iconName: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(white: 0.95, alpha: 1)
        card.layer.cornerRadius = 16
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = .systemYellow
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)

        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.font = .boldSystemFont(ofSize: 18)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let mainStack = UIStackView(arrangedSubviews: [icon, textStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            mainStack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }


    // MARK: - Actions
    @objc private func showTripSelector() {
        presenter?.showTripSelection()
    }

    @objc private func createTripTapped() {
        presenter?.didTapCreateTrip()
    }
}
