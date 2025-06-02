//
//  TripTableViewCell.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    private let avatarView = UIImageView()
    private let initialsLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let stack = UIStackView()
    private let actionStack = UIStackView()

    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    private let declineButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        avatarView.layer.cornerRadius = 20
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        initialsLabel.textAlignment = .center
        initialsLabel.backgroundColor = .systemYellow
        initialsLabel.textColor = .white
        initialsLabel.layer.cornerRadius = 20
        initialsLabel.clipsToBounds = true
        initialsLabel.font = .boldSystemFont(ofSize: 18)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        initialsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        stack.axis = .vertical
        stack.spacing = 4

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)

        actionStack.axis = .horizontal
        actionStack.spacing = 8
        actionStack.addArrangedSubview(declineButton)
        actionStack.addArrangedSubview(acceptButton)

        let hStack = UIStackView(arrangedSubviews: [avatarView, initialsLabel, stack, dateLabel, actionStack])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with trip: TripPreview) {
        titleLabel.text = trip.title
        subtitleLabel.text = trip.subtitle
        dateLabel.text = trip.dateInfo

        switch trip.avatar {
        case .image(let imageName):
            avatarView.isHidden = false
            initialsLabel.isHidden = true
            avatarView.image = UIImage(named: imageName)
        case .initial(let initial):
            avatarView.isHidden = true
            initialsLabel.isHidden = false
            initialsLabel.text = initial
        }

        if trip.status == .invited {
            actionStack.isHidden = false
        } else {
            actionStack.isHidden = true
        }
    }
}
