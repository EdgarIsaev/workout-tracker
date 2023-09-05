//
//  ProfileViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 22.03.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let greenLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let brownLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let maxNumberLabel = UILabel(text: "0",
                                         font: .robotoBold24(),
                                         textColor: .specialGray)
    
    private let minNumberLabel = UILabel(text: "0",
                                         font: .robotoBold24(),
                                         textColor: .specialGray)
    
    private let targetLabel = UILabel(text: "TARGET: 0 workouts",
                                      font: .robotoBold16(),
                                      textColor: .specialGray)
    
    private lazy var editingButton: UIButton = {
       let button = UIButton()
        button.setTitle("Editing", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.setTitleColor(UIColor.specialGreen, for: .normal)
        button.setImage(UIImage(named: "profileEditing")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = .init(top: 0,
                                       left: 9,
                                       bottom: 0,
                                       right: 0)
        button.tintColor = .specialGreen
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let weightLabel = UILabel(text: "Weight: 0",
                                      font: .robotoBold16(),
                                      textColor: .specialGray)
    
    private let heightLabel = UILabel(text: "Height: 0",
                                      font: .robotoBold16(),
                                      textColor: .specialGray)
    
    private let nameLabel = UILabel(text: "Your name",
                                    font: .robotoBold24(),
                                    textColor: .white)
    
    private let userPhotoView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let behaindPhotoView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileLabel = UILabel(text: "PROFILE",
                                       font: .robotoMedium24(),
                                       textColor: .specialGray)
    
    private let workoutsCollection = ProfileCollectionView()
    
    private var completedWorkouts = 0
    private var targetInt = 0
    private lazy var greenLineWidthConstraint = greenLineView.widthAnchor.constraint(equalToConstant: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workoutsCollection.reloadCollection()
        setupUserParametrs()
    }
    
    override func viewDidLayoutSubviews() {
        userPhotoView.layer.cornerRadius = userPhotoView.frame.width / 2
        brownLineView.layer.cornerRadius = brownLineView.frame.height / 2
        greenLineView.layer.cornerRadius = greenLineView.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressAnimation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground

        view.addSubview(profileLabel)
        view.addSubview(behaindPhotoView)
        view.addSubview(userPhotoView)
        view.addSubview(nameLabel)
        view.addSubview(heightLabel)
        view.addSubview(weightLabel)
        view.addSubview(editingButton)
        view.addSubview(workoutsCollection)
        view.addSubview(targetLabel)
        view.addSubview(minNumberLabel)
        view.addSubview(maxNumberLabel)
        maxNumberLabel.textAlignment = .right
        view.addSubview(brownLineView)
        view.addSubview(greenLineView)
    }
    
    @objc private func editingButtonTapped() {
        let editingProfileViewController = EditingProfileViewController()
        editingProfileViewController.modalPresentationStyle = .fullScreen
        present(editingProfileViewController, animated: true)
    }
    
    private func setupUserParametrs() {
        let userArray = RealmManager.shared.getResultsUserModel()
        
        if userArray.count != 0 {
            nameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            heightLabel.text = "Height: \(userArray[0].userHeight)"
            weightLabel.text = "Weight: \(userArray[0].userWeight)"
            targetLabel.text = "TARGET: \(userArray[0].userTarget)"
            maxNumberLabel.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data) else { return }
            
            userPhotoView.image = image
            targetInt = userArray[0].userTarget
        }
    }

    private func getCompletedWorkouts() {
        let workouts = RealmManager.shared.getResultsWorkoutModel()
        let predicate = NSPredicate(format: "workoutStatus == true")
        let filtredArray = workouts.filter(predicate).sorted(byKeyPath: "workoutStatus")
        completedWorkouts = filtredArray.count
        minNumberLabel.text = "\(completedWorkouts)"
    }
    
}

// MARK: Animation

extension ProfileViewController {
    
    private func progressAnimation() {
        if targetInt != 0 {
            getCompletedWorkouts()
            let workoutsPersent = completedWorkouts * 100 / targetInt
            let greenLinePersent = Int(self.brownLineView.frame.width) * workoutsPersent / 100
            
            UIView.animate(withDuration: 1, delay: 0) {[weak self] in
                guard let self = self else {return}
                self.greenLineWidthConstraint.constant = CGFloat(greenLinePersent)
                view.layoutSubviews()
            }
        }
        
    }
}

//MARK: Set Constraints

extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            behaindPhotoView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 65),
            behaindPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            behaindPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            behaindPhotoView.heightAnchor.constraint(equalToConstant: 115),
            
            userPhotoView.centerXAnchor.constraint(equalTo: behaindPhotoView.centerXAnchor),
            userPhotoView.centerYAnchor.constraint(equalTo: behaindPhotoView.topAnchor),
            userPhotoView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: behaindPhotoView.centerXAnchor),
            
            heightLabel.topAnchor.constraint(equalTo: behaindPhotoView.bottomAnchor, constant: 5),
            heightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            heightLabel.widthAnchor.constraint(equalToConstant: 85),
            heightLabel.heightAnchor.constraint(equalToConstant: 20),
            
            weightLabel.topAnchor.constraint(equalTo: behaindPhotoView.bottomAnchor, constant: 5),
            weightLabel.leadingAnchor.constraint(equalTo: heightLabel.trailingAnchor, constant: 15),
            weightLabel.widthAnchor.constraint(equalToConstant: 85),
            weightLabel.heightAnchor.constraint(equalToConstant: 20),
            
            editingButton.topAnchor.constraint(equalTo: behaindPhotoView.bottomAnchor, constant: 5),
            editingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editingButton.widthAnchor.constraint(equalToConstant: 80),
            editingButton.heightAnchor.constraint(equalToConstant: 20),
            
            workoutsCollection.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 25),
            workoutsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutsCollection.heightAnchor.constraint(equalToConstant: 250),
            
            targetLabel.topAnchor.constraint(equalTo: workoutsCollection.bottomAnchor, constant: 20),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            targetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            targetLabel.heightAnchor.constraint(equalToConstant: 20),
            
            minNumberLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 20),
            minNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            minNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            minNumberLabel.heightAnchor.constraint(equalToConstant: 25),
            
            maxNumberLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 20),
            maxNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            maxNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            maxNumberLabel.heightAnchor.constraint(equalToConstant: 25),
            
            brownLineView.topAnchor.constraint(equalTo: maxNumberLabel.bottomAnchor),
            brownLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brownLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            brownLineView.heightAnchor.constraint(equalToConstant: 30),
            
            greenLineView.topAnchor.constraint(equalTo: maxNumberLabel.bottomAnchor),
            greenLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            greenLineView.heightAnchor.constraint(equalToConstant: 30),
            greenLineWidthConstraint
        ])
    }
}
