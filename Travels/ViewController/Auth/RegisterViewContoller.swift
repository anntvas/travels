//
//  RegisterViewContoller.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import Foundation
import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    // MARK: - UI
    private let nameTextField = createTextField(placeholder: "Имя")
    private let phoneTextField = createTextField(placeholder: "Телефон", keyboardType: .phonePad)
    private let passwordTextField: UITextField = {
        let tf = createTextField(placeholder: "Пароль")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: "#FFDD2D")
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Регистрация"
        setupViews()
        setupConstraints()
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup
    private func setupViews() {
        [nameTextField, phoneTextField, passwordTextField, registerButton].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            registerButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func registerButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Заполните все поля")
            return
        }

        let registerRequest = RegisterRequest(
            username: phone,
            password: password,
            phone: phone,
            firstName: name,
            lastName: "Woods",
            email: "anita@example.com"
        )

        // Используем NetworkManager.shared вместо provider
        NetworkManager.shared.register(request: registerRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResponse):
                    // Сохраняем пользователя в CoreData
                    self?.saveUserToCoreData(userResponse)
                    
                    // Возвращаемся на экран авторизации
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    self?.showAlert(message: "Ошибка регистрации: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func saveUserToCoreData(_ userResponse: UserResponse) {
        let context = DataController.shared.context
        let user = User(context: context)
        user.id = Int64(userResponse.id)
        user.username = userResponse.username
        user.firstName = userResponse.firstName
        user.lastName = userResponse.lastName
        user.phone = userResponse.phone
        user.email = userResponse.email
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения пользователя: \(error)")
        }
    }

    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private static func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = UIColor(hex: "#F7F8F8")
        tf.borderStyle = .roundedRect
        tf.keyboardType = keyboardType
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
}
 
