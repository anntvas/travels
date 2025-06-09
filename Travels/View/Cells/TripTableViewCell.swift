//
//  TripTableViewCell.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit

protocol TripTableViewCellDelegate: AnyObject {
    func tripCellDidTapAccept(_ cell: TripTableViewCell)
    func tripCellDidTapDecline(_ cell: TripTableViewCell)
}

class TripTableViewCell: UITableViewCell {
    
    var tripId: Int?
    
    weak var delegate: TripTableViewCellDelegate?

    private let avatarView = UIImageView()
    private let initialsLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let infoStack = UIStackView()
    private let actionStack = UIStackView()

    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }()

    private let declineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
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
        selectionStyle = .none

        avatarView.layer.cornerRadius = 28
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 56).isActive = true

        initialsLabel.textAlignment = .center
        initialsLabel.backgroundColor = .systemYellow
        initialsLabel.textColor = .white
        initialsLabel.layer.cornerRadius = 28
        initialsLabel.clipsToBounds = true
        initialsLabel.font = .boldSystemFont(ofSize: 24)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.widthAnchor.constraint(equalToConstant: 56).isActive = true
        initialsLabel.heightAnchor.constraint(equalToConstant: 56).isActive = true

        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(subtitleLabel)
        infoStack.addArrangedSubview(dateLabel)

        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.addArrangedSubview(declineButton)
        actionStack.addArrangedSubview(acceptButton)
        actionStack.translatesAutoresizingMaskIntoConstraints = false

        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.widthAnchor.constraint(equalToConstant: 56).isActive = true
        avatarContainer.heightAnchor.constraint(equalToConstant: 56).isActive = true
        avatarContainer.addSubview(avatarView)
        avatarContainer.addSubview(initialsLabel)

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            initialsLabel.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            initialsLabel.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            initialsLabel.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            initialsLabel.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
        ])

        let hStack = UIStackView(arrangedSubviews: [avatarContainer, infoStack, actionStack])
        hStack.axis = .horizontal
        hStack.spacing = 16
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 92)
        ])
        acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(handleDecline), for: .touchUpInside)
    }
    
    @objc private func handleAccept() {
        delegate?.tripCellDidTapAccept(self)
    }

    @objc private func handleDecline() {
        delegate?.tripCellDidTapDecline(self)
    }

    func configure(with trip: TripPreview) {
        self.tripId = trip.id // Assuming TripPreview has an `id` property
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
            initialsLabel.text = initial
            initialsLabel.isHidden = false
        }

        actionStack.isHidden = trip.status == .confirmed
    }
}
