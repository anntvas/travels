//
//  ThirdViewController.swift
//  Travels
//
//  Created by Anna on 17.04.2025.
//

import Foundation
import UIKit
import CoreData

class ThirdViewController: UIViewController {
    
    // MARK: - UI Elements
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(hex: "#FFDD2D").cgColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить фото", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tintColor = UIColor(hex: "#FFDD2D")
        return button
    }()
    
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private var currentUser: User?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
        setupGestures()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Профиль"
        
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, changePhotoButton, nameLabel, phoneLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Выход из аккаунта",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "currentUserId")
            
            // Возврат на экран входа
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let loginVC = ViewController() // Подставь свой экран входа
                let nav = UINavigationController(rootViewController: loginVC)
                sceneDelegate.window?.rootViewController = nav
            }
        })

        present(alert, animated: true)
    }

    // MARK: - Data Loading
    private func loadUserData() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUserId"),
              let uuid = UUID(uuidString: userId) else { return }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            currentUser = try DataController.shared.context.fetch(request).first
            updateUI()
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    private func updateUI() {
        guard let user = currentUser else { return }
        
        nameLabel.text = user.name ?? "Имя не указано"
        phoneLabel.text = user.phone ?? "Телефон не указан"
        
        if let avatarData = user.avatarData {
            avatarImageView.image = UIImage(data: avatarData)
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        }
    }
    
    // MARK: - Actions
    @objc private func changePhotoTapped() {
        showImagePickerOptions()
    }
    
    @objc private func avatarTapped() {
        showImagePickerOptions()
    }
    
    private func showImagePickerOptions() {
        let alert = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Сделать фото", style: .default) { _ in
                self.showImagePicker(for: .camera)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            self.showImagePicker(for: .photoLibrary)
        })
        
        if currentUser?.avatarData != nil {
            alert.addAction(UIAlertAction(title: "Удалить фото", style: .destructive) { _ in
                self.removeAvatar()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showImagePicker(for sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func removeAvatar() {
        currentUser?.avatarData = nil
        saveContext()
        updateUI()
    }
    
    private func saveContext() {
        do {
            try DataController.shared.context.save()
        } catch {
            print("Error saving avatar: \(error)")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ThirdViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // Оптимизируем изображение перед сохранением
        let compressedImage = image.jpegData(compressionQuality: 0.7)
        currentUser?.avatarData = compressedImage
        
        saveContext()
        avatarImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
