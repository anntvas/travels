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
import CoreData

class FirstViewController: UIViewController {

    private var currentTrip: Trip?
    private var allTrips: [Trip] = []
    private let titleButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialTrips()
        setupNavigationBar()
        setupUI()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterTripCreation), name: NSNotification.Name("TripCreated"), object: nil)
    }

    // MARK: - Initial Data
    private func loadInitialTrips() {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else { return }

        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %lld", Int64(userId))

        guard let user = try? DataController.shared.context.fetch(userRequest).first else { return }

        let tripRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        tripRequest.predicate = NSPredicate(format: "createdBy == %lld", user.id)
        tripRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]

        allTrips = (try? DataController.shared.context.fetch(tripRequest)) ?? []
        currentTrip = allTrips.first
    }

    @objc private func reloadAfterTripCreation() {
        loadInitialTrips()
        view.subviews.forEach { $0.removeFromSuperview() }
        setupUI()
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(createTripTapped)
        )
        addButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = addButton
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

        // Информационные карточки
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

    // MARK: - Trip switching
    @objc private func showTripSelector() {
        guard !allTrips.isEmpty else { return }

        let alert = UIAlertController(title: "Выберите поездку", message: nil, preferredStyle: .actionSheet)

        for trip in allTrips {
            let title = trip.title ?? "Без названия"
            alert.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.currentTrip = trip
                self?.reloadAfterTripCreation()
            })
        }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func showParticipantsList() {
        guard let participants = currentTrip?.participants as? Set<Participant> else { return }

        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.modalPresentationStyle = .pageSheet

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -20)
        ])

        for participant in participants {
            let label = UILabel()
            let name = participant.name ?? "Без имени"
            let phone = participant.contact ?? "—"
            label.text = "\(name) \n\(phone)"
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 16)
            stack.addArrangedSubview(label)
        }

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        present(vc, animated: true)
    }

    @objc private func createTripTapped() {
        let tripVC = TripDetailsViewController()

        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        guard userId != 0 else { return }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(userId))

        if let user = try? DataController.shared.context.fetch(request).first {
            tripVC.currentUser = user
        }

        let nav = UINavigationController(rootViewController: tripVC)
        present(nav, animated: true)
    }
}
