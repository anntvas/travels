//
//  RegisterPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
protocol RegisterViewProtocol: AnyObject {
    func showError(message: String)
    func registrationSuccess()
}

protocol RegisterPresenterProtocol {
    func registerButtonTapped(username: String?, firstName: String?, lastName: String?, email: String?, phone: String?, password: String?)
}

final class RegisterPresenter: RegisterPresenterProtocol {
    private weak var view: RegisterViewProtocol?
    private let model: RegisterModelProtocol
    private let router: RegisterRouterProtocol
    
    init(view: RegisterViewProtocol, model: RegisterModelProtocol, router: RegisterRouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func registerButtonTapped(username: String?, firstName: String?, lastName: String?, email: String?, phone: String?, password: String?) {
        guard let username = username, !username.isEmpty,
              let firstName = firstName, !firstName.isEmpty,
              let lastName = lastName, !lastName.isEmpty,
              let email = email, !email.isEmpty,
              let phone = phone, !phone.isEmpty,
              let password = password, !password.isEmpty else {
            view?.showError(message: "Заполните все поля")
            return
        }
        
        model.registerUser(
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.registrationSuccess()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}

