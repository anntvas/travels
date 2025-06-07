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
    func displayPieChartData(_ entries: [PieChartDataEntry])
    func displayCategories(_ categories: [(title: String, amount: String, color: UIColor)])
    func displayParticipants(_ participants: [(name: String, subtitle: String?, color: UIColor)])
    func displayExpenses(_ expenses: [(name: String, category: String, amount: String, color: UIColor)])
}

protocol TripDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class TripDetailPresenter: TripDetailPresenterProtocol {
    weak var view: TripDetailViewProtocol?
    private let model: TripDetailModelProtocol

    init(view: TripDetailViewProtocol, model: TripDetailModelProtocol) {
        self.view = view
        self.model = model
    }

    func viewDidLoad() {
        let trip = model.loadTripData()

        view?.displayTripTitle(trip.title ?? "Название поездки")
        view?.displayRoute("\(trip.departureCity ?? "") - \(trip.destinationCity ?? "")")
        view?.displayBudget("Общий бюджет: \(Int(trip.budget?.totalBudget ?? 0)) ₽")

        view?.displayPieChartData([
            PieChartDataEntry(value: 40000, label: "Отели"),
            PieChartDataEntry(value: 20000, label: "Питание"),
            PieChartDataEntry(value: 12000, label: "Развлечения")
        ])

        view?.displayCategories([
            ("Отели", "40 000 ₽", .systemYellow),
            ("Питание", "20 000 ₽", .systemPurple),
            ("Развлечения", "12 000 ₽", .systemBlue)
        ])

        view?.displayParticipants([
            ("Ева", "Админ", .systemYellow),
            ("Руслан", nil, .systemBlue),
            ("Анна", nil, .systemPurple),
            ("ещё 4...", "Ольга, Дима, Дмитрий, Евчик", .systemGreen)
        ])

        view?.displayExpenses([
            ("Ева", "Отель", "40 000 ₽", .systemYellow),
            ("Руслан", "Развлечения", "5 000 ₽", .systemBlue),
            ("Анна", "Питание", "7 000 ₽", .systemPurple)
        ])
    }
}
