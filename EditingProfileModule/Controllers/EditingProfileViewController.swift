//
//  EditingProfileViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 23.03.2023.
//

import UIKit
import PhotosUI

class EditingProfileViewController: UIViewController {
    
    private let closeButton = CloseButton()
    
    private let saveButton = GreenButton(text: "SAVE")
    
    private let weightView = LabelTextFieldView(text: "Weight")
    
    private let heightView = LabelTextFieldView(text: "Height")
    
    private let secondNameView = LabelTextFieldView(text: "Second name")
    
    private let firstNameView = LabelTextFieldView(text: "First name")
    
    private let targetView = LabelTextFieldView(text: "Target")
    
    private let userPhotoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addPhoto")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
        imageView.tintColor = .white
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backPhotoView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel = UILabel(text: "EDITING PROFILE",
                                    font: .robotoMedium24(),
                                    textColor: .specialGray)
    
    private var stackView = UIStackView()
    
    private var userModel = UserModel()
    
    override func viewDidLayoutSubviews() {
        userPhotoImage.layer.cornerRadius = userPhotoImage.frame.width / 2
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
        addTaps()
        loadUserInfo()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(nameLabel)
        view.addSubview(backPhotoView)
        view.addSubview(userPhotoImage)
        stackView = UIStackView(arrangedSubViews: [firstNameView,
                                                   secondNameView,
                                                   heightView,
                                                   weightView,
                                                   targetView],
                                axis: .vertical,
                                spacing: 15)
        view.addSubview(stackView)
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        setUserModel()
        saveUserModel()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func userPhotoImageTapped() {
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            
            if #available(iOS 14, *) {
                self.presentPHPicker()
            } else {
                self.chooseImagePicker(source: source)
            }
            
        }
    }
    
    private func addTaps() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(userPhotoImageTapped))
        userPhotoImage.isUserInteractionEnabled = true
        userPhotoImage.addGestureRecognizer(tapScreen)
    }
    
    private func setUserModel() {
        userModel.userFirstName = firstNameView.getTextFieldText()
        userModel.userSecondName = secondNameView.getTextFieldText()
        userModel.userHeight = heightView.getIntFromString()
        userModel.userWeight = weightView.getIntFromString()
        userModel.userTarget = targetView.getIntFromString()
        
        if userPhotoImage.image == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
//            guard let imageData = userPhotoImage.image?.pngData() else {
//                return
//            }
//            userModel.userImage = imageData
            guard let image = userPhotoImage.image else { return }
            let jpegData = image.jpegData(compressionQuality: 1.0)
            userModel.userImage = jpegData
        }
    }
    
    private func saveUserModel() {
        let firstNameText = firstNameView.getTextFieldText()
        let secondNameText = secondNameView.getTextFieldText()
        
        let firstNameCount = firstNameText.filter { $0.isNumber || $0.isLetter }.count
        let secondNameCount = secondNameText.filter { $0.isNumber || $0.isLetter }.count
        
        if firstNameCount != 0 &&
            secondNameCount != 0 &&
            userModel.userFirstName != "" &&
            userModel.userSecondName != "" {
            
            let userArray = RealmManager.shared.getResultsUserModel()
            
            if userArray.count == 0 {
                RealmManager.shared.saveUserModel(userModel)
            } else {
                RealmManager.shared.updateUserModel(model: userModel)
            }
            
            presentSimpleAlert(title: "Success", message: nil)
            userModel = UserModel()
        }
        else {
            presentSimpleAlert(title: "Error", message: "Enter your First name and Second name")
        }
    }
    
    private func loadUserInfo() {
        let userArray = RealmManager.shared.getResultsUserModel()
        
        if userArray.count != 0 {
            firstNameView.fillingTextField(text: userArray[0].userFirstName)
            secondNameView.fillingTextField(text: userArray[0].userSecondName)
            heightView.fillingTextField(text: "\(userArray[0].userHeight)")
            weightView.fillingTextField(text: "\(userArray[0].userWeight)")
            targetView.fillingTextField(text: "\(userArray[0].userTarget)")
            
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data) else {
                return
            }
            userPhotoImage.image = image
            userPhotoImage.contentMode = .scaleAspectFill
            
        }
    }
}

extension EditingProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userPhotoImage.image = image
        userPhotoImage.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}

@available(iOS 14, *)
extension EditingProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.userPhotoImage.image = image
                    self.userPhotoImage.contentMode = .scaleAspectFill
                }
                
            }
        }
    }
    private func presentPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}

extension EditingProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            backPhotoView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 65),
            backPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backPhotoView.heightAnchor.constraint(equalToConstant: 70),
            
            userPhotoImage.centerXAnchor.constraint(equalTo: backPhotoView.centerXAnchor),
            userPhotoImage.centerYAnchor.constraint(equalTo: backPhotoView.topAnchor),
            userPhotoImage.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImage.widthAnchor.constraint(equalToConstant: 100),
            
            firstNameView.heightAnchor.constraint(equalToConstant: 60),
            secondNameView.heightAnchor.constraint(equalToConstant: 60),
            heightView.heightAnchor.constraint(equalToConstant: 60),
            weightView.heightAnchor.constraint(equalToConstant: 60),
            targetView.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: backPhotoView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
