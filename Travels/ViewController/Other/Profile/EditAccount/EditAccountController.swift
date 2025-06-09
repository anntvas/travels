//
//  EditAccountController.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

final class EditAccountViewController: UIViewController, EditAccountViewProtocol {

    var presenter: EditAccountPresenterProtocol?

    private let nameField = UITextField()
    private let phoneField = UITextField()
    private let passwordField = UITextField()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Изменения"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameField, phoneField, passwordField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [nameField, phoneField, passwordField].forEach {
            $0.borderStyle = .roundedRect
            $0.backgroundColor = UIColor.systemGray6
        }

        nameField.placeholder = "Имя"
        phoneField.placeholder = "Телефон"
        passwordField.placeholder = "Пароль"
        passwordField.isSecureTextEntry = true

        saveButton.setTitle("Сохранить изменения", for: .normal)
        saveButton.backgroundColor = UIColor.systemGray6
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 44),
            phoneField.heightAnchor.constraint(equalToConstant: 44),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func saveTapped() {
        presenter?.didTapSave(
            name: nameField.text,
            phone: phoneField.text,
            password: passwordField.text
        )
    }

    func showSuccess() {
        let alert = UIAlertController(title: "Успешно", message: "Изменения сохранены", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
