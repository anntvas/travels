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
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.backgroundColor = UIColor(hex: "#F7F8F8")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Телефон"
        textField.backgroundColor = UIColor(hex: "#F7F8F8")
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.backgroundColor = UIColor(hex: "#F7F8F8")
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .custom) // Лучше использовать .custom для полного контроля
        button.backgroundColor = UIColor(hex: "#FFDD2D")
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Регистрация"
        
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func registerButtonTapped() {
            guard let name = nameTextField.text, !name.isEmpty,
                  let phone = phoneTextField.text, !phone.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(message: "Заполните все поля")
                return
            }
            
            // Сохранение в Core Data
            let context = DataController.shared.context
            let user = User(context: context)
            user.id = UUID()
            user.name = name
            user.phone = phone
            user.password = password // В реальном приложении используйте хеширование!
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                showAlert(message: "Ошибка сохранения: \(error.localizedDescription)")
            }
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } 
}
