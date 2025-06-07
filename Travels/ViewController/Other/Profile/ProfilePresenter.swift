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
        view?.showLoading()
        model.loadLocalUser { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                self?.handleUserResult(result)
            }
        }
    }

    func onViewWillAppear() {
        view?.showLoading()
        model.loadRemoteUser { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                self?.handleUserResult(result)
            }
        }
    }

    private func handleUserResult(_ result: Result<UserResponse, Error>) {
        switch result {
        case .success(let user):
            view?.showUser(user)
        case .failure(let error):
            view?.showError(error.localizedDescription)
        }
    }

    func onAvatarTapped() {
        // может быть расширено под открытие меню
    }

    func onImageSelected(_ image: UIImage) {
        view?.updateAvatar(image)
        model.saveAvatar(image: image)
    }
}
