//
//  TripParticipantsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripParticipantsPresenterProtocol {
    func addParticipant(name: String, phone: String)
    func removeParticipant(at index: Int)
    func nextTapped()
    func getParticipantsCount() -> Int
    func getParticipant(at index: Int) -> Participant
    func attachView(_ view: TripParticipantsViewProtocol)
}

protocol TripParticipantsViewProtocol: AnyObject {
    func reloadParticipants()
    func showAlert(message: String)
}

final class TripParticipantsPresenter: TripParticipantsPresenterProtocol {
    private weak var view: TripParticipantsViewProtocol?
    private let model: TripParticipantsModelProtocol
    private let router: TripParticipantsRouterProtocol
    private var participants: [Participant] = []
    private var currentUser: User?

    init(model: TripParticipantsModelProtocol, router: TripParticipantsRouterProtocol, currentUser: User?) {
        self.model = model
        self.router = router
        self.currentUser = currentUser
    }
    
    func attachView(_ view: TripParticipantsViewProtocol) {
        self.view = view
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
        router.navigateToBudgetScreen(user: currentUser)
    }

    func getParticipantsCount() -> Int {
        return participants.count
    }

    func getParticipant(at index: Int) -> Participant {
        return participants[index]
    }
}
