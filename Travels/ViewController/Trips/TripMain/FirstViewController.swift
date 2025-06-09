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
        titleButton.titleLabel?.textAlignment = .left // Left align main title
        titleButton.contentHorizontalAlignment = .left
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

    // Step 1: Update makeInfoCard to accept a tag
    private func makeInfoCard(title: String, amount: String, iconName: String?, tag: Int, customImageName: String? = nil) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(white: 0.95, alpha: 1)
        card.layer.cornerRadius = 20
        card.heightAnchor.constraint(equalToConstant: 90).isActive = true
        card.tag = tag

        if let customImageName = customImageName {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 11)
            titleLabel.textAlignment = .left // Left align

            let amountLabel = UILabel()
            amountLabel.text = amount
            amountLabel.font = .boldSystemFont(ofSize: 18)
            amountLabel.textAlignment = .left // Left align

            let imageView = UIImageView(image: UIImage(named: customImageName))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true

            let vStack = UIStackView(arrangedSubviews: [titleLabel, amountLabel, imageView])
            vStack.axis = .vertical
            vStack.alignment = .leading // Left align stack
            vStack.spacing = 10
            vStack.translatesAutoresizingMaskIntoConstraints = false

            card.addSubview(vStack)
            NSLayoutConstraint.activate([
                vStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
                vStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),
                vStack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
            ])
            
        } else {
            let icon = UIImageView(image: iconName != nil ? UIImage(systemName: iconName!) : nil)
            icon.tintColor = .systemBlue
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 40).isActive = true

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 11)
            titleLabel.textAlignment = .left // Left align

            let amountLabel = UILabel()
            amountLabel.text = amount
            amountLabel.font = .boldSystemFont(ofSize: 18)
            amountLabel.textAlignment = .left // Left align

            let textStack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
            textStack.axis = .vertical
            textStack.spacing = 4
            textStack.alignment = .leading // Left align stack

            let mainStack = UIStackView(arrangedSubviews: [icon, textStack])
            mainStack.axis = .horizontal
            mainStack.alignment = .center
            mainStack.spacing = 12
            mainStack.translatesAutoresizingMaskIntoConstraints = false

            card.addSubview(mainStack)
            NSLayoutConstraint.activate([
                mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                mainStack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
            ])
        }

        card.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        card.addGestureRecognizer(tap)

        return card
    }

    // Step 2: Assign unique tags in updateUI
    private func updateUI(currentTrip: Trip?) {
        // Remove all except placeholder
        while stackView.arrangedSubviews.count > 0 {
            stackView.arrangedSubviews.last?.removeFromSuperview()
        }

        let operationsCard = makeInfoCard(title: "Все операции", amount: "52 000", iconName: nil, tag: 0, customImageName: "expenses")
        let participantsCard = makeInfoCard(title: "Участники", amount: "", iconName: nil, tag: 1, customImageName: "participants")
        let topCardsStack = UIStackView(arrangedSubviews: [operationsCard, participantsCard])
        topCardsStack.axis = .horizontal
        topCardsStack.spacing = 16
        topCardsStack.distribution = .fillEqually
        stackView.addArrangedSubview(topCardsStack)

        stackView.addArrangedSubview(titleButton)

        let title = currentTrip?.title ?? "Нет активных поездок"
        titleButton.setTitle(title, for: .normal)

        guard let trip = currentTrip else {
            placeholderLabel.isHidden = false
            stackView.addArrangedSubview(placeholderLabel)
            return
        }

        placeholderLabel.isHidden = true

        let budget = makeInfoCard(title: "Бюджет", amount: "\(Int(trip.budgetEntity?.totalBudget ?? 0)) ₽", iconName: "rublesign.circle.fill", tag: 2)
        let myExpenses = makeInfoCard(title: "Мои траты", amount: "100 ₽", iconName: "wallet.pass.fill", tag: 3)
        let myDebts = makeInfoCard(title: "Мои долги", amount: "0 ₽", iconName: "creditcard.fill", tag: 4)
        let owedToMe = makeInfoCard(title: "Мне должны", amount: "5000 ₽", iconName: "wallet.pass", tag: 5)

        [budget, myExpenses, myDebts, owedToMe].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    // Step 3: Update cardTapped to use the tag
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view else { return }
        presenter?.didTapCard(with: card.tag)
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
    
    func displayTripSelection(trips: [Trip]) {
        let alert = UIAlertController(title: "Select Trip", message: nil, preferredStyle: .actionSheet)
        for trip in trips {
            alert.addAction(UIAlertAction(title: trip.title, style: .default) { _ in
                self.presenter?.didSelectTrip(trip)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
