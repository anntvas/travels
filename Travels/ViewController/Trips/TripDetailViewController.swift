//
//  TripDetailViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit
import CoreData
import DGCharts

class TripDetailViewController: UIViewController {

    var trip: Trip!

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let titleLabel = UILabel()
    private let routeLabel = UILabel()
    private let budgetLabel = UILabel()
    private let pieChart = PieChartView()

    private let categoriesStack = UIStackView()
    private let participantsStack = UIStackView()
    private let expensesStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContent()
        layoutUI()
    }

    func configure(with trip: Trip) {
        self.trip = trip
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func setupContent() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = trip?.title ?? "Название поездки"

        let routeText = "\(trip?.departureCity ?? "") - \(trip?.destinationCity ?? "")"
        let routeCard = createCard(with: routeLabel, text: routeText, bgColor: .systemYellow)

        budgetLabel.font = .boldSystemFont(ofSize: 22)
        let budgetValue = trip?.budget?.totalBudget ?? 0
        budgetLabel.text = "Общий бюджет: \(budgetValue) ₽"

        setupPieChart()
        setupCategoryBreakdown()
        setupParticipantsSection()
        setupExpensesSection()

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(routeCard)
        contentStack.addArrangedSubview(budgetLabel)
        contentStack.addArrangedSubview(pieChart)
        contentStack.addArrangedSubview(categoriesStack)
        contentStack.addArrangedSubview(participantsStack)
        contentStack.addArrangedSubview(expensesStack)
    }

    private func layoutUI() {}

    private func createCard(with label: UILabel, text: String, bgColor: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = bgColor
        card.layer.cornerRadius = 12
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10)
        ])
        return card
    }

    private func setupPieChart() {
        let entries = [
            PieChartDataEntry(value: 40000, label: "Отели"),
            PieChartDataEntry(value: 20000, label: "Питание"),
            PieChartDataEntry(value: 12000, label: "Развлечения")
        ]
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.sliceSpace = 2
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.legend.enabled = false
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    private func setupCategoryBreakdown() {
        categoriesStack.axis = .vertical
        categoriesStack.spacing = 4

        let categories = [
            ("Отели", "40 000 ₽", UIColor.systemYellow),
            ("Питание", "20 000 ₽", UIColor.systemPurple),
            ("Развлечения", "12 000 ₽", UIColor.systemBlue)
        ]

        for (title, amount, color) in categories {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 8

            let colorView = UIView()
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 5
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.widthAnchor.constraint(equalToConstant: 10).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 10).isActive = true

            let label = UILabel()
            label.text = "\(title)  \(amount)"
            label.font = .systemFont(ofSize: 14)

            hStack.addArrangedSubview(colorView)
            hStack.addArrangedSubview(label)
            categoriesStack.addArrangedSubview(hStack)
        }
    }

    private func setupParticipantsSection() {
        participantsStack.axis = .vertical
        participantsStack.spacing = 8

        let title = UILabel()
        title.text = "Участники поездки"
        title.font = .boldSystemFont(ofSize: 18)
        participantsStack.addArrangedSubview(title)

        let participants = [
            ("Ева", "Админ", UIColor.systemYellow),
            ("Руслан", nil, UIColor.systemBlue),
            ("Анна", nil, UIColor.systemPurple),
            ("ещё 4...", "Ольга, Дима, Дмитрий, Евчик", UIColor.systemGreen)
        ]

        for (name, subtitle, color) in participants {
            let view = createParticipantCard(name: name, subtitle: subtitle, color: color)
            participantsStack.addArrangedSubview(view)
        }
    }

    private func createParticipantCard(name: String, subtitle: String?, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false

        let colorCircle = UIView()
        colorCircle.backgroundColor = color
        colorCircle.layer.cornerRadius = 15
        colorCircle.translatesAutoresizingMaskIntoConstraints = false
        colorCircle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        colorCircle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 16)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .gray

        let textStack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let hStack = UIStackView(arrangedSubviews: [colorCircle, textStack])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center

        card.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10)
        ])

        return card
    }

    private func setupExpensesSection() {
        expensesStack.axis = .vertical
        expensesStack.spacing = 8

        let title = UILabel()
        title.text = "Расходы участников"
        title.font = .boldSystemFont(ofSize: 18)
        expensesStack.addArrangedSubview(title)

        let expenses = [
            ("Ева", "Отель", "40 000 ₽", UIColor.systemYellow),
            ("Руслан", "Развлечения", "5 000 ₽", UIColor.systemBlue),
            ("Анна", "Питание", "7 000 ₽", UIColor.systemPurple)
        ]

        for (name, category, amount, color) in expenses {
            let button = createExpenseCard(name: name, category: category, amount: amount, color: color)
            expensesStack.addArrangedSubview(button)
        }
    }

    private func createExpenseCard(name: String, category: String, amount: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left

        let colorCircle = UIView()
        colorCircle.backgroundColor = color
        colorCircle.layer.cornerRadius = 12
        colorCircle.translatesAutoresizingMaskIntoConstraints = false
        colorCircle.widthAnchor.constraint(equalToConstant: 24).isActive = true
        colorCircle.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 16)

        let categoryLabel = UILabel()
        categoryLabel.text = category
        categoryLabel.font = .systemFont(ofSize: 13)
        categoryLabel.textColor = .gray

        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.font = .systemFont(ofSize: 16)
        amountLabel.textAlignment = .right

        let nameStack = UIStackView(arrangedSubviews: [nameLabel, categoryLabel])
        nameStack.axis = .vertical

        let hStack = UIStackView(arrangedSubviews: [colorCircle, nameStack, amountLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.distribution = .equalSpacing

        button.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: button.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
        ])

        button.addTarget(self, action: #selector(expenseTapped), for: .touchUpInside)
        return button
    }

    @objc private func expenseTapped() {
        let detailVC = ExpenseDetailViewController() // или другой контроллер
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
