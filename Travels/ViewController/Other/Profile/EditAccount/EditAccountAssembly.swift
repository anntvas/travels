//
//  EditAccountAssembly.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

enum EditAccountAssembly {
    static func build() -> UIViewController {
        let view = EditAccountViewController()
        let model = EditAccountModel()
        let presenter = EditAccountPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
