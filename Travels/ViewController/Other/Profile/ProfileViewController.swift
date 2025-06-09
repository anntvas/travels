//
//  ProfileViewController.swift
//  Travels
//
//  Created by Anna on 01.06.2025.
//


import UIKit
import PhotosUI

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    var presenter: ProfilePresenterProtocol?

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        return imageView
    }()

    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить фото", for: .normal)
        return button
    }()
    private let editAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить аккаунт", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    

    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let emailLabel = UILabel()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            avatarImageView,
            changePhotoButton,
            nameLabel,
            phoneLabel,
            emailLabel,
            editAccountButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    private func setupUI() {
        nameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        nameLabel.textAlignment = .center
        phoneLabel.font = .systemFont(ofSize: 17)
        phoneLabel.textAlignment = .center
        phoneLabel.textColor = .secondaryLabel
        emailLabel.font = .systemFont(ofSize: 17)
        emailLabel.textAlignment = .center
        emailLabel.textColor = .secondaryLabel

        view.addSubview(stack)
        view.addSubview(errorLabel)
        view.addSubview(loadingIndicator)

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
            errorLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20)
        ])

        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(onAvatarTap))
        avatarImageView.addGestureRecognizer(avatarTap)
        changePhotoButton.addTarget(self, action: #selector(onAvatarTap), for: .touchUpInside)
        editAccountButton.addTarget(self, action: #selector(editAccountTapped), for: .touchUpInside)
    }

    @objc private func onAvatarTap() {
        presenter?.onAvatarTapped()
        showImagePickerOptions()
    }
    
    @objc private func editAccountTapped() {
        print("helo")
        presenter?.editAccountTapped()
    }

    private func showImagePickerOptions() {
        let alert = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Сделать фото", style: .default) { _ in self.openCamera() })
        }

        alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in self.openGallery() })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    private func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    private func openGallery() {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }

    // MARK: - ProfileViewProtocol
    

    func showLoading() {
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    func showUser(_ user: UserResponse) {
        errorLabel.isHidden = true
        nameLabel.text = "\(user.firstName) \(user.lastName)".trimmingCharacters(in: .whitespaces)
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }

    func updateAvatar(_ image: UIImage) {
        avatarImageView.image = image
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            presenter?.onImageSelected(image)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

@available(iOS 14, *)
extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, _) in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.presenter?.onImageSelected(image)
                }
            }
        }
    }
}
