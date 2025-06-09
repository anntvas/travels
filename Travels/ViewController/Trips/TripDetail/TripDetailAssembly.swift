//
//  TripDetailAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

// TripDetailAssembly.swift
enum TripDetailAssembly {
    static func build(tripId: Int) -> UIViewController {
        let view = TripDetailViewController()
        let model = TripDetailModel(tripId: tripId)
        let router = TripDetailRouter(viewController: view)
        let presenter = TripDetailPresenter(
            view: view,
            model: model,
            tripId: tripId,
            router: router
        )
        view.presenter = presenter
        return view
    }
}
