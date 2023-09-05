//
//  RepsWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 18.03.2023.
//

import UIKit

class RepsWorkoutViewController: UIViewController {
    
    private let finishButton = GreenButton(text: "FINISH")
    
    private let workoutParametrsView = WorkoutParametrsView()
    
    private let detailsLabel = UILabel(text: "Details")
    
    let imageWorkout: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "sportsman")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let closeButton = CloseButton()
    
    private let startWorkoutLabel = UILabel(text: "START WORKOUT",
                                            font: .robotoMedium24(),
                                            textColor: .specialGray)
    
    private var workoutModel = WorkoutModel()
    private var customAlert: CustomAlert?
    private var numberOfSet = 1
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        print(workoutModel)
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(imageWorkout)
        view.addSubview(detailsLabel)
        workoutParametrsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        workoutParametrsView.cellNextSetDelegate = self
        view.addSubview(workoutParametrsView)
        view.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            presentAlertWithAction(title: "Warning", message: "You have not finished your workout. Do you want continue?") {
                self.dismiss(animated: true)
            }
        }
            
    }
    
    public func setWorkoutModel(model: WorkoutModel) {
        workoutModel = model
    }
}

//MARK: NextSetProtocol

extension RepsWorkoutViewController: NextSetProtocol {
    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametrsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        }
        else {
            presentSimpleAlert(title: "Complete", message: "Finish your workout")
        }
    }
    
    func editingTapped() {
        customAlert = CustomAlert()
        customAlert?.presentCustomAlert(viewController: self,
                                        repsOrTimer: "Reps") { [weak self] sets, reps in
            guard let self = self else { return }
            if sets != "" && reps != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfReps = Int(reps) else { return }
                RealmManager.shared.updateSetsRepsWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               reps: numberOfReps)
                self.workoutParametrsView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
            self.customAlert = nil
        }
    }
}

//MARK: SetConstraints

extension RepsWorkoutViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([

            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            imageWorkout.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 30),
            imageWorkout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageWorkout.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            imageWorkout.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            detailsLabel.topAnchor.constraint(equalTo: imageWorkout.bottomAnchor, constant: 10),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsLabel.heightAnchor.constraint(equalToConstant: 20),
            
            workoutParametrsView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor),
            workoutParametrsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutParametrsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutParametrsView.heightAnchor.constraint(equalToConstant: 230),
            
            finishButton.topAnchor.constraint(equalTo: workoutParametrsView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
