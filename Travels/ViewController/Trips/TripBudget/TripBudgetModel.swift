//
//  TripBudgetModel.swift
//  Travels
//
//  Created by Anna on 03.06.2025.
//

import Foundation

protocol TripBudgetModelProtocol {
    func saveBudget(_ budget: Double)
}

final class TripBudgetModel: TripBudgetModelProtocol {
    func saveBudget(_ budget: Double) {
        TripCreationManager.shared.totalBudget = budget
    }
}
