//
//  AuthPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
protocol AuthViewProtocol: AnyObject {
    func showError(message: String)
    func showLoading()
    func hideLoading()
}
protocol AuthPresenterProtocol {
    func login(phone: String, password: String)
    func registerButtonTapped()
}

final class AuthPresenter: AuthPresenterProtocol {
    private weak var view: AuthViewProtocol?
    private let model: AuthModelProtocol
    private let router: AuthRouterProtocol
    
    init(view: AuthViewProtocol, model: AuthModelProtocol, router: AuthRouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func login(phone: String, password: String) {
        guard !phone.isEmpty, !password.isEmpty else {
            view?.showError(message: "Заполните все поля")
            return
        }
        
        view?.showLoading()
        
        model.login(phone: phone, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success:
                    self?.router.navigateToMainScreen()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func registerButtonTapped() {
        router.navigateToRegister()
    }
}

