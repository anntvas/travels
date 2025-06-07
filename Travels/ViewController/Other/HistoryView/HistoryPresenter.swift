//
//  HistoryPresenter.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation

protocol HistoryViewProtocol: AnyObject {
    func showHistory(_ items: [String])
}

protocol HistoryPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func clearHistory()
}

final class HistoryPresenter: HistoryPresenterProtocol {
    private weak var view: HistoryViewProtocol?
    private let model: HistoryModelProtocol
    
    init(view: HistoryViewProtocol, model: HistoryModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func onViewDidLoad() {
        view?.showHistory(model.fetchHistory())
    }
    
    func clearHistory() {
        model.clearAll()
        view?.showHistory([])
    }
}
