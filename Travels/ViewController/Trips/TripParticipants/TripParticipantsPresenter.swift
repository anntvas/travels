//
//  TripParticipantsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripParticipantsViewProtocol: AnyObject {
    func reloadParticipants()
    func showAlert(message: String)
    func navigateToBudgetScreen()
}

final class TripParticipantsPresenter {
    weak var view: TripParticipantsViewProtocol?
    private let model: TripParticipantsModelProtocol
    private let router: TripParticipantsRouterProtocol
    var participants: [Participant] = []
    var currentUser: User?

    init(view: TripParticipantsViewProtocol, model: TripParticipantsModelProtocol, router: TripParticipantsRouterProtocol, currentUser: User?) {
        self.view = view
        self.model = model
        self.router = router
        self.currentUser = currentUser
    }

    func addParticipant(name: String, phone: String) {
        let newParticipant = model.createParticipant(name: name, phone: phone)
        participants.append(newParticipant)
        view?.reloadParticipants()
    }

    func removeParticipant(at index: Int) {
        participants.remove(at: index)
        view?.reloadParticipants()
    }

    func nextTapped() {
        guard !participants.isEmpty else {
            view?.showAlert(message: "Добавьте хотя бы одного участника")
            return
        }
        TripCreationManager.shared.participants = participants
        router.navigateToBudgetScreen(from: view as! UIViewController, user: currentUser)
    }

    func getParticipantsCount() -> Int {
        return participants.count
    }

    func getParticipant(at index: Int) -> Participant {
        return participants[index]
    }
}
