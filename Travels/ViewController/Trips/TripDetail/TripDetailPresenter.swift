//
//  TripDetailPresenter.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import Foundation
import DGCharts
import UIKit
protocol TripDetailViewProtocol: AnyObject {
    func displayTripTitle(_ title: String)
    func displayRoute(_ route: String)
    func displayBudget(_ total: String)
    func displayPieChartData(entries: [PieChartDataEntry], colors: [UIColor])
    func displayCategories(_ categories: [(title: String, amount: String, color: UIColor)])
    func displayParticipants(_ participants: [(name: String, subtitle: String?, color: UIColor)])
    func displayExpenses(_ expenses: [(name: String, category: String, amount: String, color: UIColor)])
}

protocol TripDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func addExpenseButtonTapped()
}

final class TripDetailPresenter: TripDetailPresenterProtocol {
    weak var view: TripDetailViewProtocol?
    private let model: TripDetailModelProtocol
    private let router: TripDetailRouterProtocol
    private let tripId: Int

    init(view: TripDetailViewProtocol,
         model: TripDetailModelProtocol,
         tripId: Int,
         router: TripDetailRouterProtocol) {
        self.view = view
        self.model = model
        self.tripId = tripId
        self.router = router
    }
    
    func viewDidLoad() {
        loadTripInfo()
        loadParticipants()
        loadExpenses()
    }
    
    private func loadTripInfo() {
        model.fetchTrip { [weak self] result in
            switch result {
            case .success(let trip):
                self?.view?.displayTripTitle(trip.title ?? "Без названия")
                self?.view?.displayRoute("\(trip.departureCity ?? "") - \(trip.destinationCity ?? "")")

                self?.model.fetchTripBudget { budgetResult in
                    DispatchQueue.main.async {
                        switch budgetResult {
                        case .success(let total):
                            self?.view?.displayBudget("Общий бюджет: \(Int(total)) ₽")
                        case .failure:
                            self?.view?.displayBudget("Бюджет не загружен")
                        }
                    }
                }
                
                self?.model.fetchBudgetCategories { [weak self] result in
                    switch result {
                    case .success(let categories):
                        let entries = categories.map { PieChartDataEntry(value: $0.amount, label: $0.name) }
                        let uiColors: [UIColor] = [
                            .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemPink, .systemRed, .systemTeal, .systemYellow
                        ]
                        let mappedColors = Array(uiColors.prefix(entries.count))

                        DispatchQueue.main.async {
                            self?.view?.displayPieChartData(entries: entries, colors: mappedColors)
                        }

                    case .failure(let error):
                        print("Ошибка загрузки категорий бюджета: \(error)")
                    }
                }


            case .failure(let error):
                print("Ошибка загрузки поездки: \(error)")
            }
        }
    }
    private func loadParticipants() {
        model.fetchParticipants { [weak self] result in
            switch result {
            case .success(let participants):
                let formatted = participants.map {
                    (
                        name: $0.name,
                        subtitle: $0.contact,
                        color:  UIColor.systemBlue // можно кастомизировать по id/роли
                    )
                }
                DispatchQueue.main.async {
                    self?.view?.displayParticipants(formatted)
                }
            case .failure(let error):
                print("❌ Ошибка загрузки участников: \(error.localizedDescription)")
            }
        }
    }

    private func loadExpenses() {
        model.fetchExpenses { [weak self] result in
            switch result {
            case .success(let expenses):
                let formatted = expenses.map {
                    (
                        name: "юзер",
                        category: String($0.category ?? 2),
                        amount: String(format: "%.2f ₽", $0.amount),
                        color: UIColor.systemBlue // или по категории
                    )
                }
                DispatchQueue.main.async {
                    self?.view?.displayExpenses(formatted)
                }
            case .failure(let error):
                print("❌ Ошибка загрузки расходов: \(error.localizedDescription)")
            }
        }
    }

    func addExpenseButtonTapped() {
        router.navigateToAddExpense(tripId: tripId)
    }

}
