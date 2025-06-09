//
//  BottomSheetViewController.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

class BottomSheetViewController: UIViewController {

    private let backgroundView = UIView()
    let sheetView = UIView()
    private let sheetHeightRatio: CGFloat = 0.7 // 70% экрана

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupSheetView()
        setupTapToDismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePresentation()
    }

    private func setupBackground() {
        view.backgroundColor = .clear

        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupSheetView() {
        sheetView.backgroundColor = .systemBackground
        sheetView.layer.cornerRadius = 20
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sheetView)

        let height = UIScreen.main.bounds.height * sheetHeightRatio

        NSLayoutConstraint.activate([
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetView.heightAnchor.constraint(equalToConstant: height)
        ])

        // Пример содержимого:
        let label = UILabel()
        label.text = "Это bottom sheet"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        sheetView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: sheetView.centerYAnchor)
        ])
    }

    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        backgroundView.addGestureRecognizer(tap)
    }

    @objc private func dismissTapped() {
        dismiss(animated: true)
    }

    private func animatePresentation() {
        sheetView.transform = CGAffineTransform(translationX: 0, y: sheetView.frame.height)
        backgroundView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.sheetView.transform = .identity
            self.backgroundView.alpha = 1
        })

    }
}
