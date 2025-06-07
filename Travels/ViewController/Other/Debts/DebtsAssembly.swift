//
//  DebtsAssembly.swift
//  Travels
//
//  Created by Anna on 06.06.2025.
//

import Foundation
import UIKit

enum DebtsAssembly {
    static func build() -> UIViewController {
        let view = DebtsViewController()
        let model = DebtsModel()
        let presenter = DebtsPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
