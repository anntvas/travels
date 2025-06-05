//
//  TripParticipantsAssembly.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import UIKit

enum TripParticipantsAssembly {
    static func build(user: User?) -> UIViewController {
        let model = TripParticipantsModel()
        let router = TripParticipantsRouter()
        let presenter: TripParticipantsPresenterProtocol = TripParticipantsPresenter(model: model, router: router, currentUser: user)
        let view = TripParticipantsViewController(presenter: presenter)
        presenter.attachView(view)
        router.setViewController(view)
        return view
    }
}
