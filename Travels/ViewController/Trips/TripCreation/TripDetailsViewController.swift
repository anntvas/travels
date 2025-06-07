//
//  TripDetailsViewController.swift
//  Travels
//
//  Created by Anna on 29.05.2025.
//

import UIKit

final class TripDetailsViewController: UIViewController, TripDetailsViewProtocol {
    var presenter: TripDetailsPresenterProtocol?

    private let titleField = UITextField()
    private let fromCityField = UITextField()
    private let toCityField = UITextField()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let nextButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Создание поездки"
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        [titleField, fromCityField, toCityField].forEach {
            $0.borderStyle = .roundedRect
        }
        titleField.placeholder = "Название поездки"
        fromCityField.placeholder = "Город отправления"
        toCityField.placeholder = "Город назначения"

        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
        endDatePicker.minimumDate = Date()

        nextButton.setTitle("Далее", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        activityIndicator.hidesWhenStopped = true

        [titleField, fromCityField, toCityField, startDatePicker,
         endDatePicker, nextButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

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
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func nextTapped() {
        presenter?.nextButtonTapped(
            title: titleField.text,
            fromCity: fromCityField.text,
            toCity: toCityField.text,
            startDate: startDatePicker.date,
            endDate: endDatePicker.date
        )
    }

    // MARK: - TripDetailsViewProtocol

    func showValidationError(message: String) {
        showAlert(title: "Ошибка", message: message)
    }

    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    func showTripCreationSuccess() {
        showAlert(title: "Успех", message: "Поездка создана")
    }

    func showTripCreationError(message: String) {
        showAlert(title: "Ошибка", message: message)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
