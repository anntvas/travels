//
//  TripDetailViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit
import DGCharts

final class TripDetailViewController: UIViewController, TripDetailViewProtocol {
    var presenter: TripDetailPresenterProtocol?

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
        addGradientBackground()
        setupScrollView()
        layoutUI()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
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

    private func layoutUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        contentStack.addArrangedSubview(titleLabel)

        routeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        routeLabel.numberOfLines = 0
        routeLabel.textColor = .black
        contentStack.addArrangedSubview(wrapInCard(view: routeLabel, bgColor: UIColor.systemYellow))

        budgetLabel.font = .boldSystemFont(ofSize: 22)
        contentStack.addArrangedSubview(wrapInCard(view: budgetLabel, bgColor: .white))

        let chartAndCategories = UIStackView(arrangedSubviews: [pieChart, categoriesStack])
        chartAndCategories.axis = .vertical
        chartAndCategories.spacing = 12
        contentStack.addArrangedSubview(wrapInCard(view: chartAndCategories, bgColor: .white))

        contentStack.addArrangedSubview(wrapInCard(view: participantsStack, bgColor: .white))
        contentStack.addArrangedSubview(wrapInCard(view: expensesStack, bgColor: .white))
    }

    private func wrapInCard(view: UIView, bgColor: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = bgColor
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        return container
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addExpenseButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addExpenseButtonTapped() {
        presenter?.addExpenseButtonTapped()
    }

    func displayTripTitle(_ title: String) {
        titleLabel.text = title
    }

    func displayRoute(_ route: String) {
        routeLabel.text = route
    }

    func displayBudget(_ total: String) {
        budgetLabel.text = total
    }

    func displayPieChartData(entries: [PieChartDataEntry], colors: [UIColor]) {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.sliceSpace = 2
        dataSet.colors = colors

        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 12))

        pieChart.data = data
        pieChart.legend.enabled = false
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func displayCategories(_ categories: [(title: String, amount: String, color: UIColor)]) {
        categoriesStack.axis = .vertical
        categoriesStack.spacing = 4
        categoriesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

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

    func displayParticipants(_ participants: [(name: String, subtitle: String?, color: UIColor)]) {
        participantsStack.axis = .vertical
        participantsStack.spacing = 8
        participantsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let title = UILabel()
        title.text = "Участники поездки"
        title.font = .boldSystemFont(ofSize: 18)
        participantsStack.addArrangedSubview(title)

        for (name, subtitle, color) in participants {
            let view = createParticipantCard(name: name, subtitle: subtitle, color: color)
            participantsStack.addArrangedSubview(view)
        }
    }

    func displayExpenses(_ expenses: [(name: String, category: String, amount: String, color: UIColor)]) {
        expensesStack.axis = .vertical
        expensesStack.spacing = 8
        expensesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let title = UILabel()
        title.text = "Расходы участников"
        title.font = .boldSystemFont(ofSize: 18)
        expensesStack.addArrangedSubview(title)

        for (name, category, amount, color) in expenses {
            let button = createExpenseCard(name: name, category: category, amount: amount, color: color)
            expensesStack.addArrangedSubview(button)
        }
    }

    private func createParticipantCard(name: String, subtitle: String?, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12

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

    private func addGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor.systemGray.cgColor,
            UIColor.white.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        view.layer.insertSublayer(gradient, at: 0)
    }

    @objc private func expenseTapped() {
        let detailVC = ExpenseDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
