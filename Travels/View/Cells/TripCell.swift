//
//  TripCell.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

class TripCell: UITableViewCell {
    static let identifier = "TripCell"

    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        return label
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonStackView)

        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(cancelButton)

        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: buttonStackView.leadingAnchor, constant: -12),

            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func confirmTapped() {
        confirmAction?()
    }

    @objc private func cancelTapped() {
        cancelAction?()
    }

    func configure(with trip: Trip) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var text = (trip.title ?? "Без названия") + "\n"

        if let dep = trip.departureCity, let dest = trip.destinationCity {
            text += "\(dep) → \(dest)\n"
        }

        if let start = trip.startDate, let end = trip.endDate {
            text += "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }

        titleLabel.text = text
    }

    func hideButtons() {
        buttonStackView.isHidden = true
    }

    func showButtons() {
        buttonStackView.isHidden = false
    }
}
