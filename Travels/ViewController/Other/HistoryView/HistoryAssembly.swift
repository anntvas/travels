//
//  HistoryAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit
enum HistoryAssembly {
    static func build() -> UIViewController {
        let view = HistoryViewController()
        let model = HistoryModel()
        let presenter = HistoryPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
