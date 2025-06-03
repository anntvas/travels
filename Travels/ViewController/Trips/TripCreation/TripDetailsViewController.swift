//
//  TripDetailsViewController.swift
//  Travels
//
//  Created by Anna on 29.05.2025.
//

import UIKit

final class TripDetailsViewController: UIViewController, TripDetailsViewProtocol {

    var presenter: TripDetailsPresenter!

    private let titleField = UITextField()
    private let fromCityField = UITextField()
    private let toCityField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Создание поездки"
        setupUI()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func goToParticipants(for user: User?) {
        presenter.router.navigateToParticipants(from: self, user: user)
    }

    private func setupUI() {
        titleField.placeholder = "Название поездки"
        fromCityField.placeholder = "Город отправления"
        toCityField.placeholder = "Город назначения"

        [titleField, fromCityField, toCityField, startDatePicker, endDatePicker, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        titleField.borderStyle = .roundedRect
        fromCityField.borderStyle = .roundedRect
        toCityField.borderStyle = .roundedRect
        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date

        nextButton.setTitle("Далее", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            fromCityField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 12),
            fromCityField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            fromCityField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            toCityField.topAnchor.constraint(equalTo: fromCityField.bottomAnchor, constant: 12),
            toCityField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            toCityField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            startDatePicker.topAnchor.constraint(equalTo: toCityField.bottomAnchor, constant: 20),
            startDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            endDatePicker.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 12),
            endDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func nextTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let start = formatter.string(from: startDatePicker.date)
        let end = formatter.string(from: endDatePicker.date)

        presenter.didTapNext(
            title: titleField.text,
            from: fromCityField.text,
            to: toCityField.text,
            startDate: start,
            endDate: end
        )
    }
}
