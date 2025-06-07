//
//  BudgetCategoryCell.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import Foundation
import UIKit

class BudgetCategoryCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - UI Elements
    private let nameLabel = UILabel()
    private let amountField = UITextField()
    private let slider = UISlider()
    private let stackView = UIStackView()

    var onAmountChanged: ((Double) -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none

        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        amountField.keyboardType = .decimalPad
        amountField.borderStyle = .roundedRect
        amountField.textAlignment = .right
        amountField.delegate = self
        amountField.addTarget(self, action: #selector(amountFieldChanged), for: .editingChanged)
        amountField.widthAnchor.constraint(equalToConstant: 100).isActive = true

        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = 0

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let horizontalStack = UIStackView(arrangedSubviews: [nameLabel, amountField])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        horizontalStack.distribution = .fill

        stackView.addArrangedSubview(horizontalStack)
        stackView.addArrangedSubview(slider)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Public
    func configure(with category: BudgetCategoryModel, totalBudget: Double) {
        nameLabel.text = category.category
        amountField.text = category.allocatedAmount > 0 ? "\(category.allocatedAmount.formattedWithSeparator)" : ""
        slider.maximumValue = totalBudget.isNaN ? 0 : Float(totalBudget)
        slider.value = category.allocatedAmount.isNaN ? 0 : Float(category.allocatedAmount)
    }

    // MARK: - Actions
    @objc private func amountFieldChanged() {
        guard let text = amountField.text else { return }
        let amount = Double(text) ?? 0
        slider.value = Float(amount)
        onAmountChanged?(amount)
    }

    @objc private func sliderValueChanged() {
        let amount = Double(slider.value)
        amountField.text = amount > 0 ? "\(amount.formattedWithSeparator)" : ""
        onAmountChanged?(amount)
    }

    // MARK: - Validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
