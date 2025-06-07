//
//  TripBudgetConfirmModel.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
protocol TripBudgetConfirmModelProtocol {
    var totalBudget: Double { get }
}
final class TripBudgetConfirmModel: TripBudgetConfirmModelProtocol {
    let totalBudget: Double
    
    init(totalBudget: Double = TripCreationManager.shared.totalBudget) {
        self.totalBudget = totalBudget
    }
}
