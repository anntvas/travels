//
//  TripDetailsViewController.swift
//  Travels
//
//  Created by Anna on 29.05.2025.
//

import Foundation
import UIKit
import CoreData

class TripDetailsViewController: UIViewController {

    var currentUser: User!

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
        guard let title = titleField.text, !title.isEmpty,
              let fromCity = fromCityField.text, !fromCity.isEmpty,
              let toCity = toCityField.text, !toCity.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }

        // Сохраняем данные в менеджер
        // Пример создания поездки
        let tripRequest = TripRequest(
            title: titleField.text!,
            description: "Летний отпуск с поездкой на море",
            startDate: formatDate(from: startDatePicker),
            endDate: formatDate(from: endDatePicker),
            departureCity: fromCityField.text!,
            destinationCity: toCityField.text!,
            createdBy: 1
        )

        NetworkManager.shared.createTrip(trip: tripRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tripResponse):
                    print("Поездка создана: \(tripResponse)")
                    // Обновить UI или перейти к следующему экрану
                case .failure(let error):
                    print("Ошибка создания поездки: \(error.localizedDescription)")
                    // Показать ошибку пользователю
                }
            }
        }

        let participantsVC = TripParticipantsViewController()
        participantsVC.currentUser = currentUser
        navigationController?.pushViewController(participantsVC, animated: true)
    }
    
    func formatDate(from datePicker: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: datePicker.date)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
