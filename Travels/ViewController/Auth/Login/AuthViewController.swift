//
//  AuthViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import UIKit

final class AuthViewController: UIViewController, AuthViewProtocol {
    var presenter: AuthPresenterProtocol!
    
    private let phoneTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .custom)
    private let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        title = ""
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        phoneTextField.backgroundColor = UIColor(hex: "#F7F8F8")
        phoneTextField.placeholder = "Телефон"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .phonePad
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.backgroundColor = UIColor(hex: "#F7F8F8")
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.backgroundColor = UIColor(hex: "#FFDD2D")
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.layer.cornerRadius = 15
        loginButton.layer.masksToBounds = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        let attributedTitle = NSMutableAttributedString(
            string: "Еще не зарегистрированы? ",
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.gray]
        )
        attributedTitle.append(NSAttributedString(
            string: "Регистрация",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue]
        ))
        registerButton.setAttributedTitle(attributedTitle, for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func loginButtonTapped() {
        presenter.login(
            phone: phoneTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    @objc private func registerButtonTapped() {
        presenter.registerButtonTapped()
    }
    
    // MARK: AuthViewProtocol
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        // Реализация индикатора загрузки
        view.isUserInteractionEnabled = false
        // Показать activity indicator
    }
    
    func hideLoading() {
        // Скрытие индикатора загрузки
        view.isUserInteractionEnabled = true
        // Скрыть activity indicator
    }
    
}
