//
//  TripParticipantsAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

enum TripParticipantsAssembly {
    static func build(user: User?) -> UIViewController {
        let view = TripParticipantsViewController()
        let model = TripParticipantsModel()
        let router = TripParticipantsRouter()
        let presenter = TripParticipantsPresenter(
            view: view,
            model: model,
            router: router,
            currentUser: user
        )
        view.presenter = presenter
        return view
    }
}
