//
//  ParticipantCell.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import UIKit

final class ParticipantCell: UITableViewCell {
    let nameLabel = UILabel()
    let contactLabel = UILabel()
    let iconView = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contactLabel.font = UIFont.systemFont(ofSize: 14)
        contactLabel.textColor = .gray

        iconView.textAlignment = .center
        iconView.backgroundColor = UIColor.systemBlue
        iconView.textColor = .white
        iconView.font = UIFont.boldSystemFont(ofSize: 18)
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contactLabel)

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            contactLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            contactLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            contactLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            contactLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with participant: ParticipantResponse) {
        nameLabel.text = participant.name
        contactLabel.text = participant.contact
        if let first = participant.name.first {
            iconView.text = String(first).uppercased()
        } else {
            iconView.text = "?"
        }
    }
}
