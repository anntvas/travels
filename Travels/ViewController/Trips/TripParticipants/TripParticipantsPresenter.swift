//
//  TripParticipantsPresenter.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation
import UIKit

protocol TripParticipantsPresenterProtocol {
    func viewDidLoad()
    func didTapAddParticipant()
    func didTapNextButton()
    func didDeleteParticipant(at index: Int)
    func numberOfParticipants() -> Int
    func participant(at index: Int) -> Participant
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
    private var participants: [Participant] = []
    private let user: User
    
    init(
        view: TripParticipantsViewProtocol,
        model: TripParticipantsModelProtocol,
        router: TripParticipantsRouterProtocol,
        user: User
    ) {
        self.view = view
        self.model = model
        self.router = router
        self.user = user
    }
    
    func viewDidLoad() {
        participants = model.fetchParticipants()
        view?.reloadTableView()
    }
    
    func didTapAddParticipant() {
        showAddParticipantAlert()
    }
    
    private func showAddParticipantAlert() {
        let alert = UIAlertController(
            title: "Добавить участника",
            message: "Введите имя и номер телефона участника",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Номер телефона"
            textField.keyboardType = .phonePad
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?[0].text, !name.isEmpty,
                  let phone = alert.textFields?[1].text, !phone.isEmpty else {
                return
            }
            
            self.view?.showLoading()
            self.model.addParticipant(name: name, phone: phone) { [weak self] result in
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    switch result {
                    case .success(let participant):
                        self?.participants.append(participant)
                        self?.view?.reloadTableView()
                    case .failure(let error):
                        self?.view?.showError(message: error.localizedDescription)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        (view as? UIViewController)?.present(alert, animated: true)
    }
    
    func didTapNextButton() {
        guard !participants.isEmpty else {
            view?.showError(message: "Добавьте хотя бы одного участника")
            return
        }
        router.navigateToTripBudget(with: user, participants: participants)
    }
    
    func didDeleteParticipant(at index: Int) {
        guard index >= 0 && index < participants.count else { return }
        let participant = participants[index]
        model.deleteParticipant(participant)
        participants.remove(at: index)
        view?.reloadTableView()
    }
    
    func numberOfParticipants() -> Int {
        return participants.count
    }
    
    func participant(at index: Int) -> Participant {
        return participants[index]
    }
}
