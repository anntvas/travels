//
//  EditAccountPresenter.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import Foundation
protocol EditAccountViewProtocol: AnyObject {
    func showSuccess()
    func showError(_ message: String)
}

protocol EditAccountPresenterProtocol: AnyObject {
    func didTapSave(name: String?, phone: String?, password: String?)
}

final class EditAccountPresenter: EditAccountPresenterProtocol {
    weak var view: EditAccountViewProtocol?
    let model: EditAccountModelProtocol

    init(view: EditAccountViewProtocol, model: EditAccountModelProtocol) {
        self.view = view
        self.model = model
    }

    func didTapSave(name: String?, phone: String?, password: String?) {
        model.updateAccount(name: name, phone: phone, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.showSuccess()
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
