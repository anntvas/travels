//
//  DebtsPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol DebtsViewProtocol: AnyObject {
    func showDebts(_ debts: [String])
}

protocol DebtsPresenterProtocol {
    func onViewDidLoad()
}

final class DebtsPresenter: DebtsPresenterProtocol {
    private weak var view: DebtsViewProtocol?
    private let model: DebtsModelProtocol
    
    init(view: DebtsViewProtocol, model: DebtsModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func onViewDidLoad() {
        let debts = model.fetchDebts()
        view?.showDebts(debts)
    }
}
