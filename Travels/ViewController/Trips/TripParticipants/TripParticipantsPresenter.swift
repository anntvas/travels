//
//  TripParticipantsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

protocol TripParticipantsPresenterProtocol: AnyObject {
    var participants: [Participant] { get }
    func viewDidLoad()
    func showAddParticipantAlert()
    func didTapNextButton()
}

protocol TripParticipantsViewProtocol: AnyObject {
    func reloadTableView()
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

final class TripParticipantsPresenter: TripParticipantsPresenterProtocol {
    weak var view: TripParticipantsViewProtocol?
    private let model: TripParticipantsModelProtocol
    private let router: TripParticipantsRouterProtocol
    internal var participants: [Participant] = []
    private let tripId: Int
    
    init(
        view: TripParticipantsViewProtocol,
        model: TripParticipantsModelProtocol,
        router: TripParticipantsRouterProtocol,
        tripId: Int
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.tripId = tripId
    }
    
    func viewDidLoad() {
    }
    
    func didTapAddParticipant() {
        showAddParticipantAlert()
    }
    
    internal func showAddParticipantAlert() {
        let alert = UIAlertController(title: "Добавить участника", message: "Введите номер телефона", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Номер телефона" }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let phone = alert.textFields?.first?.text, !phone.isEmpty else { return }
            self?.view?.showLoading()
            self?.model.addParticipant(to: self?.tripId ?? 0, phone: phone) { result in
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    switch result {
                    case .success(let response):
                        // создадим Participant для отображения в таблице
                        let participant = Participant(context: DataController.shared.context)
                        participant.name = response.name
                        participant.contact = response.contact
                        participant.confirmed = response.confirmed
                        self?.participants.append(participant)
                        self?.view?.reloadTableView()
                    case .failure(let error):
                        self?.view?.showError(message: error.localizedDescription)
                    }
                }
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        (view as? UIViewController)?.present(alert, animated: true)
    }
    
    func didTapNextButton() {
        guard !participants.isEmpty else {
            view?.showError(message: "Добавьте хотя бы одного участника")
            return
        }
        router.navigateToTripBudget(tripId: tripId)
    }
    
//    func didDeleteParticipant(at index: Int) {
//        guard index >= 0 && index < participants.count else { return }
//        let participant = participants[index]
//        model.deleteParticipant(participant)
//        participants.remove(at: index)
//        view?.reloadTableView()
//    }
    
    func numberOfParticipants() -> Int {
        return participants.count
    }
    
    func participant(at index: Int) -> Participant {
        return participants[index]
    }
}
