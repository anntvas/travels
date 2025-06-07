//
//  TripDetailsAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//
import UIKit

enum TripDetailsAssembly {
    static func build() -> UIViewController {
        let view = TripDetailsViewController()
        let model = TripDetailsModel()
        let router = TripDetailsRouter(viewController: view)
        let presenter = TripDetailsPresenter(view: view, model: model, router: router)
        view.presenter = presenter
        return view
    }
}
