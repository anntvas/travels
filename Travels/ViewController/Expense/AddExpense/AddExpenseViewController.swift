//
//  AddExpenseViewController.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import UIKit

final class AddExpenseViewController: UIViewController, AddExpenseViewProtocol {
    var presenter: AddExpensePresenterProtocol?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleTextField = UITextField()
    private let amountTextField = UITextField()
    private let categoryLabel = UILabel()
    private let categoryPicker = UIPickerView()

    private let paidByTextField = UITextField()
    private let paidByPicker = UIPickerView()

    private let forWhomLabel = UILabel()
    private let forWhomTableView = UITableView()

    private let saveButton = UIButton(type: .system)

    private var categories: [String] = []
    private var participants: [ParticipantResponse] = []
    private var selectedBeneficiaries: Set<Int> = []
    private var paidBySelectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить расход"
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Конфигурация полей
        titleTextField.placeholder = "Название расхода"
        titleTextField.borderStyle = .roundedRect

        amountTextField.placeholder = "Сумма в ₽"
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad

        categoryLabel.text = "Категория"
        categoryLabel.font = .boldSystemFont(ofSize: 16)

        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        paidByTextField.placeholder = "Кто оплатил"
        paidByTextField.borderStyle = .roundedRect
        paidByTextField.inputView = paidByPicker
        paidByPicker.delegate = self
        paidByPicker.dataSource = self

        forWhomLabel.text = "За кого оплачено"
        forWhomLabel.font = .boldSystemFont(ofSize: 16)

        forWhomTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        forWhomTableView.allowsMultipleSelection = true
        forWhomTableView.delegate = self
        forWhomTableView.dataSource = self

        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        [titleTextField, amountTextField, categoryLabel, categoryPicker,
         paidByTextField, forWhomLabel, forWhomTableView, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

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

            paidByTextField.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 16),
            paidByTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            paidByTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            forWhomLabel.topAnchor.constraint(equalTo: paidByTextField.bottomAnchor, constant: 20),
            forWhomLabel.leadingAnchor.constraint(equalTo: paidByTextField.leadingAnchor),

            forWhomTableView.topAnchor.constraint(equalTo: forWhomLabel.bottomAnchor, constant: 8),
            forWhomTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            forWhomTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            forWhomTableView.heightAnchor.constraint(equalToConstant: 200),

            saveButton.topAnchor.constraint(equalTo: forWhomTableView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func saveButtonTapped() {
        let categoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let paidById = participants[safe: paidBySelectedIndex]?.id ?? -1
        let beneficiaryIds = Array(selectedBeneficiaries)
        view.endEditing(true)

        presenter?.saveExpense(
            title: titleTextField.text,
            amount: amountTextField.text,
            categoryIndex: categoryIndex,
            paidBy: String(paidById),
            forWhom: beneficiaryIds.map { String($0) }.joined(separator: ",")
        )
    }
    
    func setSelectedCategory(_ category: String) {
        if let index = categories.firstIndex(of: category) {
            categoryPicker.selectRow(index, inComponent: 0, animated: false)
        }
    }

    // MARK: - AddExpenseViewProtocol

    func showValidationError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showSaveSuccess() {
        let alert = UIAlertController(title: "Успешно", message: "Расход сохранён", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    func showSaveError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func setCategories(_ categories: [String]) {
        self.categories = categories
        categoryPicker.reloadAllComponents()
    }

    func setParticipants(_ participants: [ParticipantResponse]) {
        self.participants = participants
        paidByPicker.reloadAllComponents()
        forWhomTableView.reloadData()
        if let first = participants.first {
            paidByTextField.text = first.name
        }
    }
}

extension AddExpenseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        } else {
            return participants.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        } else {
            return participants[safe: row]?.name
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == paidByPicker {
            paidBySelectedIndex = row
            paidByTextField.text = participants[safe: row]?.name
        }
    }
}

extension AddExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = participants[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBeneficiaries.insert(participants[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedBeneficiaries.remove(participants[indexPath.row].id)
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
