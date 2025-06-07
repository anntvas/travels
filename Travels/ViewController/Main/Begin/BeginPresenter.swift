//
//  BeginPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
protocol BeginViewProtocol: AnyObject {}

protocol BeginPresenterProtocol {
    func loginButtonTapped()
}

final class BeginPresenter: BeginPresenterProtocol {
    private weak var view: BeginViewProtocol?
    private let router: BeginRouterProtocol
    
    init(view: BeginViewProtocol, router: BeginRouterProtocol) {
        self.view = view
        self.router = router
    }
    func loginButtonTapped() {
        router.navigateToAuth()
    }
}
