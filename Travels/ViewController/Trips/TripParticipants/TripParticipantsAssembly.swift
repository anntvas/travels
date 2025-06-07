//
//  TripParticipantsAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

enum TripParticipantsAssembly {
    static func build(tripId: Int) -> UIViewController {
        let view = TripParticipantsViewController()
        let model = TripParticipantsModel()
        let router = TripParticipantsRouter(viewController: view)
        let presenter = TripParticipantsPresenter(view: view, model: model, router: router, tripId: tripId)
        view.presenter = presenter
        return view
    }
}
