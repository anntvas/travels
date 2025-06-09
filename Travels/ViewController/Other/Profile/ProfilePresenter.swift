//
//  ProfilePresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit

protocol ProfileViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showUser(_ user: UserResponse)
    func showError(_ message: String)
    func updateAvatar(_ image: UIImage)
}

protocol ProfilePresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onAvatarTapped()
    func onImageSelected(_ image: UIImage)
    func editAccountTapped()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private weak var view: ProfileViewProtocol?
    private let model: ProfileModelProtocol
    private let router: ProfileRouterProtocol

    init(view: ProfileViewProtocol, model: ProfileModelProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }

    func onViewDidLoad() {
        loadUserData()
    }
    
    private func loadUserData() {
        print("мы попали jnc.ls")
        view?.showLoading()
        print("мы попали сюда")
        model.loadUser { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let user):
                    self?.view?.showUser(user)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadAvatar() {
        model.loadAvatar { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.view?.updateAvatar(image)
                } else {
                    // Установить дефолтный аватар
                    self?.view?.updateAvatar(UIImage(systemName: "person.circle.fill")!)
                }
            }
        }
    }

    func onViewWillAppear() {
        onViewDidLoad()
    }


    private func handleUserResult(_ result: Result<UserResponse, Error>) {
        switch result {
        case .success(let user):
            view?.showUser(user)
        case .failure(let error):
            view?.showError(error.localizedDescription)
        }
    }
    
    func editAccountTapped() {
        router.navigateToEditAccount()
    }

    func onAvatarTapped() {
        // может быть расширено под открытие меню
    }

    func onImageSelected(_ image: UIImage) {
        view?.updateAvatar(image)
        model.saveAvatar(image: image)
        
        // Дополнительно: выгрузка на сервер при необходимости
        // uploadAvatarToServer(image)
    }
}
