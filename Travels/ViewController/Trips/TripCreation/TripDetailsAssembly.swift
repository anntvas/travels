//
//  TripDetailsAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

enum TripDetailsAssembly {
    static func build(user: User? = nil) -> UIViewController {
        let model = TripDetailsModel()
        let router = TripDetailsRouter()
        let presenter: TripDetailsPresenterProtocol = TripDetailsPresenter(model: model, router: router, user: user)
        let view = TripDetailsViewController(presenter: presenter)
        presenter.attachView(view)
        router.setViewController(view)
        return view
    }
}
