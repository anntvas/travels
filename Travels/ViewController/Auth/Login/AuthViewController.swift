//
//  AuthViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import Foundation
import UIKit
import CoreData
import KeychainSwift

class AuthViewController: UIViewController {
    private let keychain = KeychainSwift()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(hex: "#F7F8F8")
        textField.placeholder = "Телефон"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(hex: "#F7F8F8")
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom) // Лучше использовать .custom для полного контроля
        button.backgroundColor = UIColor(hex: "#FFDD2D")
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Еще не зарегистрированы? ",
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.gray]
        )
        attributedTitle.append(NSAttributedString(
            string: "Регистрация",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue]
        ))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = ""
        
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
        guard let phone = phoneTextField.text, !phone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Заполните все поля")
            return
        }
        
        let loginRequest = LoginRequest(username: phone, password: password)
        
        NetworkManager.shared.login(request: loginRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokenResponse):
                    // Сохраняем токены в Keychain
                    self?.keychain.set(tokenResponse.accessToken, forKey: "accessToken")
                    self?.keychain.set(tokenResponse.refreshToken, forKey: "refreshToken")
                    
                    // Сохраняем время истечения токенов
                    UserDefaults.standard.set(
                        Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn)),
                        forKey: "accessTokenExpiration"
                    )
                    UserDefaults.standard.set(
                        Date().addingTimeInterval(TimeInterval(tokenResponse.refreshExpiresIn)),
                        forKey: "refreshTokenExpiration"
                    )
                    
                    // Получаем данные пользователя
                    self?.fetchUserProfile()
                    
                case .failure(let error):
                    self?.fallbackToLocalAuth(phone: phone, password: password)
                }
            }
        }
    }
       
    private func saveUserToCoreData(_ userResponse: UserResponse) {
           let context = DataController.shared.context
           
           // Обновляем существующего пользователя или создаем нового
           let request: NSFetchRequest<User> = User.fetchRequest()
           request.predicate = NSPredicate(format: "id == %lld", Int64(userResponse.id))
           
           let currentUser: User
           if let existingUser = try? context.fetch(request).first {
               currentUser = existingUser
           } else {
               currentUser = User(context: context)
               currentUser.id = Int64(userResponse.id)
           }
           
           currentUser.username = userResponse.username
           currentUser.firstName = userResponse.firstName
           currentUser.lastName = userResponse.lastName
           currentUser.phone = userResponse.phone
           currentUser.email = userResponse.email
           
           do {
               try context.save()
               UserDefaults.standard.set(currentUser.id, forKey: "currentUserId")
           } catch {
               print("Ошибка сохранения пользователя: \(error)")
           }
       }
       
       private func fallbackToLocalAuth(phone: String, password: String) {
           // Поиск пользователя в CoreData
           let context = DataController.shared.context
           let request = NSFetchRequest<User>(entityName: "User")
           request.predicate = NSPredicate(format: "phone == %@ AND password == %@", phone, password)
           
           do {
               let users = try context.fetch(request)
               if let user = users.first {
                   // Успешная авторизация
                   UserDefaults.standard.set(user.id, forKey: "currentUserId")
                   navigateToMainScreen()
               } else {
                   showAlert(message: "Неверный телефон или пароль")
               }
           } catch {
               showAlert(message: "Ошибка авторизации: \(error.localizedDescription)")
           }
       }
    private func fetchUserProfile() {
        NetworkManager.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResponse):
                    self?.saveUserToCoreData(userResponse)
                    self?.navigateToMainScreen()
                    
                case .failure(let error as NSError) where error.code == 403:
                    // Специальная обработка 403 ошибки
                    self?.showAlert(message: "Ошибка доступа. Попробуйте войти снова.")
                    self?.clearAuthData()
                    
                case .failure(let error):
                    self?.showAlert(message: "Ошибка: \(error.localizedDescription)")
                }
            }
        }
    }

    private func clearAuthData() {
        TokenManager.shared.clearTokens()
        // Дополнительные очистки данных если нужно
    }
    private func refreshTokenAndRetryProfile() {
        NetworkManager.shared.refreshToken { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokenResponse):
                    // Сохраняем новые токены
                    self?.keychain.set(tokenResponse.accessToken, forKey: "accessToken")
                    self?.keychain.set(tokenResponse.refreshToken, forKey: "refreshToken")
                    
                    // Повторяем запрос профиля
                    self?.fetchUserProfile()
                    
                case .failure(let error):
                    self?.showAlert(message: "Ошибка обновления токена: \(error.localizedDescription)")
                    // Возвращаем на экран логина
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
        
        private func navigateToMainScreen() {
            let tabBarVC = MainTabBarController()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(to: tabBarVC)
        }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension AuthViewController {
    func showAlert(
        title: String = "Ошибка",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction]? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        // Если действия не переданы - добавляем стандартную кнопку "OK"
        if let actions = actions {
            actions.forEach { alert.addAction($0) }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        // Для iPad (если используется .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
}
