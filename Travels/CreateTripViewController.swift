//
//  CreateTripViewController.swift
//  Travels
//
//  Created by Anna on 23.05.2025.
//

import Foundation
import UIKit

class CreateTripViewController: UIViewController {

    private let titleField = UITextField()
    private let destinationField = UITextField()
    private let createButton = UIButton(type: .system)

    var onTripCreated: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        titleField.placeholder = "Название поездки"
        destinationField.placeholder = "Место назначения"

        [titleField, destinationField, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        titleField.borderStyle = .roundedRect
        destinationField.borderStyle = .roundedRect

        createButton.setTitle("Создать", for: .normal)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            destinationField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 12),
            destinationField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            destinationField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

            createButton.topAnchor.constraint(equalTo: destinationField.bottomAnchor, constant: 20),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func createTapped() {
        guard let title = titleField.text, !title.isEmpty,
              let destination = destinationField.text, !destination.isEmpty else {
            showAlert(message: "Заполните все поля")
            return
        }

        onTripCreated?(title, destination)
        dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
