//
//  AddExpenseViewController.swift
//  Travels
//
//  Created by Anna on 02.06.2025.
//

import UIKit

final class AddExpenseViewController: UIViewController, AddExpenseViewProtocol {
    var presenter: AddExpensePresenterProtocol?
    
    // UI элементы остаются теми же
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleTextField = UITextField()
    private let amountTextField = UITextField()
    private let categoryLabel = UILabel()
    private let categoryPicker = UIPickerView()
    private let paidByTextField = UITextField()
    private let forWhomTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    
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
        
        // Настройка текстовых полей
        titleTextField.placeholder = "Название расхода"
        titleTextField.borderStyle = .roundedRect
        amountTextField.placeholder = "Сумма в ₽"
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        paidByTextField.placeholder = "Кто оплатил"
        paidByTextField.borderStyle = .roundedRect
        forWhomTextField.placeholder = "За кого оплачено"
        forWhomTextField.borderStyle = .roundedRect
        
        // Настройка лейбла
        categoryLabel.text = "Категория"
        categoryLabel.font = .boldSystemFont(ofSize: 16)
        
        // Настройка пикера
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        // Настройка кнопки
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // Добавление элементов
        [titleTextField, amountTextField, categoryLabel, categoryPicker,
         paidByTextField, forWhomTextField, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // Констрейнты
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
    
    @objc private func saveButtonTapped() {
        let categoryIndex = categoryPicker.selectedRow(inComponent: 0)
        presenter?.saveExpense(
            title: titleTextField.text,
            amount: amountTextField.text,
            categoryIndex: categoryIndex,
            paidBy: paidByTextField.text,
            forWhom: forWhomTextField.text
        )
    }
    
    // MARK: - AddExpenseViewProtocol
    func showValidationError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSaveSuccess() {
        let alert = UIAlertController(title: "Успешно", message: "Расход сохранен", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
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
        categoryPicker.reloadAllComponents()
    }
    
    func setSelectedCategory(_ category: String) {
//        if let index = presenter?.categories.firstIndex(of: category) {
//            categoryPicker.selectRow(index, inComponent: 0, animated: false)
//        }
    }
}

// MARK: - UIPickerView
extension AddExpenseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return presenter?.categories.count ?? 0
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return presenter?.categories[row]
        return "csddc"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter?.categorySelected(at: row)
    }
}
