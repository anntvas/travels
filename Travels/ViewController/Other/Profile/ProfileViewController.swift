//
//  ProfileViewController.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//

import Foundation
import UIKit
import CoreData
import Moya
import KeychainSwift
import PhotosUI

class ProfileViewController: UIViewController {
    
    private var currentUser: User?
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainSwift()
    
    // UI Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        // Добавляем распознаватель жестов
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить фото", for: .normal)
        button.addTarget(self, action: #selector(didTapChangePhoto), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .systemBackground
        setupUI()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем данные при каждом открытии экрана
        loadUserDataFromServer()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            avatarImageView,
            changePhotoButton,
            nameLabel,
            phoneLabel,
            emailLabel
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        
        view.addSubview(stack)
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadUserData() {
        // Сначала пробуем загрузить из CoreData
        guard let userId = UserDefaults.standard.string(forKey: "currentUserId"),
              let uuid = UUID(uuidString: userId) else { return }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            currentUser = try DataController.shared.context.fetch(request).first
            updateUI()
        } catch {
            print("Ошибка при загрузке пользователя: \(error)")
        }
        
        // Затем обновляем с сервера
        loadUserDataFromServer()
    }
    
    private func loadUserDataFromServer() {
        guard keychain.get("accessToken") != nil else {
            showError(message: "Требуется авторизация")
            return
        }
        
        loadingIndicator.startAnimating()
        errorLabel.isHidden = true
        
        networkManager.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                
                switch result {
                case .success(let userResponse):
                    self?.saveUserToCoreData(userResponse)
                    self?.updateUI(with: userResponse)
                    
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func saveUserToCoreData(_ userResponse: UserResponse) {
        let context = DataController.shared.context
        
        // Создаем или обновляем пользователя в CoreData
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", userResponse.id)
        
        let user: User
        if let existingUser = try? context.fetch(request).first {
            user = existingUser
        } else {
            user = User(context: context)
            user.id = Int64(userResponse.id)
        }
        
        user.username = userResponse.username
        user.firstName = userResponse.firstName
        user.lastName = userResponse.lastName
        user.phone = userResponse.phone
        user.email = userResponse.email
        
        do {
            try context.save()
            UserDefaults.standard.set("\(userResponse.id)", forKey: "currentUserId")
        } catch {
            print("Ошибка сохранения пользователя: \(error)")
        }
    }
    
    private func updateUI(with userResponse: UserResponse? = nil) {
        let user: UserResponse?
        
        if let userResponse = userResponse {
            user = userResponse
        } else if let currentUser = currentUser {
            // Конвертируем CoreData User в UserResponse для унификации
            user = UserResponse(
                id: Int(currentUser.id),
                username: currentUser.username ?? "",
                firstName: currentUser.firstName ?? "",
                lastName: currentUser.lastName ?? "",
                phone: currentUser.phone ?? "",
                email: currentUser.email ?? ""
            )
        } else {
            user = nil
        }
        
        guard let user = user else {
            nameLabel.text = "Пользователь не найден"
            phoneLabel.text = ""
            emailLabel.text = ""
            return
        }
        
        nameLabel.text = "\(user.firstName) \(user.lastName)".trimmingCharacters(in: .whitespaces)
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        // Можно добавить загрузку аватара, если API поддерживает
        // loadAvatar(from: user.avatarUrl)
    }
    
    private func handleError(_ error: Error) {
        let errorMessage: String
        
        if let error = error as? NSError {
            switch error.code {
            case 401:
                errorMessage = "Требуется авторизация"
                // Можно добавить автоматическое обновление токена
            case 403:
                errorMessage = "Доступ запрещен"
            case 404:
                errorMessage = "Пользователь не найден"
            default:
                errorMessage = error.localizedDescription
            }
        } else {
            errorMessage = error.localizedDescription
        }
        
        showError(message: errorMessage)
    }
    
    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    // Пример функции для загрузки аватара
    private func loadAvatar(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.avatarImageView.image = image
                }
            }
        }.resume()
    }
    @objc private func didTapAvatar() {
            showImagePickerOptions()
        }
        
        @objc private func didTapChangePhoto() {
            showImagePickerOptions()
        }
        
        private func showImagePickerOptions() {
            let alert = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in
                    self.openCamera()
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { _ in
                self.openGallery()
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            
            present(alert, animated: true)
        }
        
        private func openCamera() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
        
        private func openGallery() {
            if #available(iOS 14, *) {
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 1
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                present(picker, animated: true)
            } else {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                present(imagePicker, animated: true)
            }
        }
        
        private func saveAvatarLocally(_ image: UIImage) {
            guard let imageData = image.jpegData(compressionQuality: 0.8),
                  let userId = UserDefaults.standard.string(forKey: "currentUserId"),
                  let uuid = UUID(uuidString: userId) else { return }
            
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            
            do {
                if let user = try DataController.shared.context.fetch(request).first {
                    user.avatarData = imageData
                    try DataController.shared.context.save()
                    avatarImageView.image = image
                }
            } catch {
                print("Ошибка сохранения аватара: \(error)")
            }
        }
    }

    // MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
    extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            
            if let editedImage = info[.editedImage] as? UIImage {
                avatarImageView.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                avatarImageView.image = originalImage
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    // MARK: - PHPickerViewControllerDelegate (для iOS 14+)
    @available(iOS 14, *)
    extension ProfileViewController: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                }
            }
        }
    }
