//
//  TripDetailAssembly.swift
//  Travels
//
//  Created by Anna on 07.06.2025.
//

import UIKit

enum TripDetailAssembly {
    static func build(with trip: Trip) -> UIViewController {
        let view = TripDetailViewController()
        let model = TripDetailModel(trip: trip)
        let presenter = TripDetailPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
