//
//  AddExpenseViewController.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название расхода"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Сумма в ₽"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let categoryPicker = UIPickerView()
    private let categories = [
        "Билеты", "Отели", "Питание", "Развлечения",
        "Страховка", "Транспорт", "Подарки", "Другое"
    ]

    private let paidByTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Кто оплатил"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let forWhomTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "За кого оплачено"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить расход"
        view.backgroundColor = .white

        setupViews()
        setupLayout()
        setupDelegates()
    }

    // MARK: - Setup
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [titleTextField, amountTextField, categoryLabel, categoryPicker,
         paidByTextField, forWhomTextField, saveButton].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let views = [titleTextField, amountTextField, categoryLabel, categoryPicker,
                     paidByTextField, forWhomTextField, saveButton]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            amountTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),

            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryPicker.heightAnchor.constraint(equalToConstant: 100),

            paidByTextField.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            paidByTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            paidByTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            forWhomTextField.topAnchor.constraint(equalTo: paidByTextField.bottomAnchor, constant: 16),
            forWhomTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            forWhomTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            saveButton.topAnchor.constraint(equalTo: forWhomTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupDelegates() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
    }
}

// MARK: - UIPickerView
extension AddExpenseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
