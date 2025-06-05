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
    
    private var presenter: FirstPresenterProtocol
    private var currentTrip: Trip?
    private var allTrips: [Trip] = []
    
    private let titleButton = UIButton(type: .system)
    
    init(presenter: FirstPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func displayTrips(current: Trip?, all: [Trip]) {
        currentTrip = current
        allTrips = all
        reloadUI()
    }
    
    private func reloadUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        setupUI()
    }
    
    @objc private func showTripSelector() {
        let alert = UIAlertController(title: "Выберите поездку", message: nil, preferredStyle: .actionSheet)
        for trip in allTrips {
            let title = trip.title ?? "Без названия"
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                self.presenter.didSelectTrip(trip)
            })
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func showParticipantsList() {
        presenter.didTapParticipants(for: currentTrip)
    }
    
    @objc private func createTripTapped() {
        presenter.didTapCreateTrip()
    }
    
    
    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        let contentView = UIView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let tripTitle = currentTrip?.title ?? "Название не указано"
        titleButton.setTitle(tripTitle, for: .normal)
        titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        titleButton.setTitleColor(.label, for: .normal)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.addTarget(self, action: #selector(showTripSelector), for: .touchUpInside)
        
        let budgetAmount = Int(currentTrip?.budget?.totalBudget ?? 0)
        let myExpenses = 100
        
        let budgetCard = makeInfoCard(title: "Бюджет", amount: "\(budgetAmount) ₽", iconName: "rublesign.circle.fill")
        let myExpensesCard = makeInfoCard(title: "Мои траты", amount: "\(myExpenses) ₽", iconName: "wallet.pass.fill")
        let myDebtsCard = makeInfoCard(title: "Мои долги", amount: "0 ₽", iconName: "creditcard.fill")
        let owedToMeCard = makeOwedCard()
        
        let cardsStack = UIStackView(arrangedSubviews: [budgetCard, myExpensesCard, myDebtsCard, owedToMeCard])
        cardsStack.axis = .vertical
        cardsStack.spacing = 12
        
        let fullStack = UIStackView(arrangedSubviews: [titleButton, cardsStack])
        fullStack.axis = .vertical
        fullStack.spacing = 24
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fullStack)
        
        NSLayoutConstraint.activate([
            fullStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            fullStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fullStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fullStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    private func makeOwedCard() -> UIView {
        let card = makeInfoCard(title: "Мне должны", amount: "5000 ₽", iconName: "wallet.pass")
        
        let avatarStack = UIStackView()
        avatarStack.axis = .horizontal
        avatarStack.spacing = -10
        
        let colors: [UIColor] = [.systemYellow, .systemBlue, .systemGray]
        let initials = ["E", "A", "O"]
        
        for (index, initial) in initials.enumerated() {
            let label = UILabel()
            label.text = initial
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.backgroundColor = colors[index % colors.count]
            label.textColor = .white
            label.layer.cornerRadius = 14
            label.layer.masksToBounds = true
            label.widthAnchor.constraint(equalToConstant: 28).isActive = true
            label.heightAnchor.constraint(equalToConstant: 28).isActive = true
            avatarStack.addArrangedSubview(label)
        }
        
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(avatarStack)
        NSLayoutConstraint.activate([
            avatarStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            avatarStack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showParticipantsList))
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true
        return card
    }
    
    private func makeInfoCard(title: String, amount: String, iconName: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(white: 0.95, alpha: 1)
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = .systemYellow
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [icon, textStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            mainStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        
        return card
    }
}
