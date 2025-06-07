//
//  RegisterViewContoller.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit

final class RegisterViewController: UIViewController, RegisterViewProtocol {
    var presenter: RegisterPresenterProtocol?

    private let usernameTextField = UITextField()
    private let nameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let phoneTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
    }

    private func setupViews() {
        [usernameTextField, nameTextField, lastNameTextField, emailTextField, phoneTextField, passwordTextField].forEach {
            $0.backgroundColor = UIColor(hex: "#F7F8F8")
            $0.borderStyle = .roundedRect
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        usernameTextField.placeholder = "Имя пользователя"
        nameTextField.placeholder = "Имя"
        lastNameTextField.placeholder = "Фамилия"
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress

        phoneTextField.placeholder = "Телефон"
        phoneTextField.keyboardType = .phonePad

        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true

        registerButton.backgroundColor = UIColor(hex: "#FFDD2D")
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        registerButton.layer.cornerRadius = 15
        registerButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(registerButton)
    }

    private func setupConstraints() {
        let fields = [usernameTextField, nameTextField, lastNameTextField, emailTextField, phoneTextField, passwordTextField]
        for (index, field) in fields.enumerated() {
            NSLayoutConstraint.activate([
                field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                field.heightAnchor.constraint(equalToConstant: 50),
                field.topAnchor.constraint(equalTo: index == 0
                    ? view.safeAreaLayoutGuide.topAnchor
                    : fields[index - 1].bottomAnchor, constant: index == 0 ? 40 : 20)
            ])
        }

        NSLayoutConstraint.activate([
                registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                registerButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                registerButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }

    @objc private func registerButtonTapped() {
        presenter?.registerButtonTapped(
            username: usernameTextField.text,
            firstName: nameTextField.text,
            lastName: lastNameTextField.text,
            email: emailTextField.text,
            phone: phoneTextField.text,
            password: passwordTextField.text
        )
    }

    // MARK: - RegisterViewProtocol
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func registrationSuccess() {
        navigationController?.popViewController(animated: true)
    }
}
