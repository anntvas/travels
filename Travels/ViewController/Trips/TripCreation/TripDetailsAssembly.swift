//
//  TripDetailsAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

enum TripDetailsAssembly {
    static func build(user: User? = nil) -> TripDetailsViewController {
        let view = TripDetailsViewController()
        let model = TripDetailsModel()
        let router = TripDetailsRouter()
        let presenter = TripDetailsPresenter(
            view: view,
            model: model,
            router: router,
            user: user
        )
        view.presenter = presenter
        return view
    }
}
