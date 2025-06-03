//
//  TripParticipantsViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit
import CoreData

class TripParticipantsViewController: UIViewController {

    var currentUser: User!
    private var participants: [Participant] = []

    private let tableView = UITableView()
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Участники поездки"

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        nextButton.setTitle("Далее", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),

            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addParticipantTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addParticipantTapped() {
        showAddParticipantAlert()
    }

    @objc private func nextTapped() {
        guard !participants.isEmpty else {
            showAlert(message: "Добавьте хотя бы одного участника")
            return
        }

        TripCreationManager.shared.participants = participants

        let budgetVC = TripBudgetViewController()
        budgetVC.currentUser = currentUser
        navigationController?.pushViewController(budgetVC, animated: true)
    }

    private func showAddParticipantAlert() {
        let alert = UIAlertController(
            title: "Добавить участника",
            message: "Введите имя и номер телефона участника",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Имя"
        }

        alert.addTextField { textField in
            textField.placeholder = "Номер телефона"
            textField.keyboardType = .phonePad
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?[0].text, !name.isEmpty,
                  let phone = alert.textFields?[1].text, !phone.isEmpty else {
                return
            }

            let context = DataController.shared.context
            let participant = Participant(context: context)
            participant.name = name
            participant.contact = phone
            participant.confirmed = true

            self.participants.append(participant)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TripParticipantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let participant = participants[indexPath.row]
        cell.textLabel?.text = "\(participant.name ?? "") (\(participant.contact ?? ""))"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            participants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
