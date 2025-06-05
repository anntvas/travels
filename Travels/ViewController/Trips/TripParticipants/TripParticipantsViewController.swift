//
//  TripParticipantsViewController.swift
//  Travels
//
//  Created by Anna on 31.05.2025.
//

import UIKit

final class TripParticipantsViewController: UIViewController, TripParticipantsViewProtocol {

    private let presenter: TripParticipantsPresenterProtocol

    private let tableView = UITableView()
    private let nextButton = UIButton(type: .system)
    
    init(presenter: TripParticipantsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        let alert = UIAlertController(
            title: "Добавить участника",
            message: "Введите имя и номер телефона участника",
            preferredStyle: .alert
        )

        alert.addTextField { $0.placeholder = "Имя" }
        alert.addTextField {
            $0.placeholder = "Номер телефона"
            $0.keyboardType = .phonePad
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let name = alert.textFields?[0].text, !name.isEmpty,
                  let phone = alert.textFields?[1].text, !phone.isEmpty else { return }

            self?.presenter.addParticipant(name: name, phone: phone)
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func nextTapped() {
        presenter.nextTapped()
    }

    func reloadParticipants() {
        tableView.reloadData()
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TripParticipantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getParticipantsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let participant = presenter.getParticipant(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(participant.name ?? "") (\(participant.contact ?? ""))"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeParticipant(at: indexPath.row)
        }
    }
}
