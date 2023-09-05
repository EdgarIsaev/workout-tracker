//
//  TimerWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 18.03.2023.
//

import UIKit
   
class TimerWorkoutViewController: UIViewController {
    
    private let finishButton = GreenButton(text: "FINISH")
    
    private let workoutParametrsView = TimerWorkoutParametrsView()
    
    private let detailsLabel = UILabel(text: "Details")
    
    private let imageWorkout: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ellipse")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let timerLabel = UILabel(text: "01:30",
                                     font: .robotoBold48(),
                                     textColor: .specialGray)
    
    private let closeButton = CloseButton()
    
    private let startWorkoutLabel = UILabel(text: "START WORKOUT",
                                            font: .robotoMedium24(),
                                            textColor: .specialGray)
    
    private var workoutModel = WorkoutModel()
    private let shapeLayer = CAShapeLayer()
    private var customAlert: CustomAlert?
    private var timer = Timer()
    
    private var durationTimer = 10
    private var numberOfSet = 0
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
        animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addTaps()
        setWorkoutParametrs()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(imageWorkout)
        view.addSubview(timerLabel)
        view.addSubview(detailsLabel)
        view.addSubview(workoutParametrsView)
        workoutParametrsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        workoutParametrsView.nextSetEditingDelegate = self
        view.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        timer.invalidate()
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        }
        else {
            presentAlertWithAction(title: "Warning", message: "You have not finished your workout. Do you want continue?") {
                self.dismiss(animated: true)
            }
        }
    }
    
    public func setWorkoutModel(model: WorkoutModel) {
        workoutModel = model
    }
    
    private func addTaps() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startTimer() {
        workoutParametrsView.buttonsIsEnable(value: false)
        
        if numberOfSet == workoutModel.workoutSets {
            presentSimpleAlert(title: "Complete", message: "Finish your workout")
        }
        else {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            workoutParametrsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
            workoutParametrsView.buttonsIsEnable(value: true)
        }
        let (min, sec) = durationTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
    }
    
    private func setWorkoutParametrs() {
        let (min, sec) = workoutModel.workoutTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
        durationTimer = workoutModel.workoutTimer
    }
    
}

//MARK: NextSetEditingProtocol

extension TimerWorkoutViewController: NextSetEditingProtocol {
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
                                       repsOrTimer: "Timer") { [weak self] sets, time in
            guard let self = self else { return }
            if sets != "" && time != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfTime = Int(time) else { return }
                RealmManager.shared.updateSetsTimeWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               time: numberOfTime)
                self.timerLabel.text = numberOfTime.convertSecondsToString()
                self.durationTimer = numberOfTime
                self.workoutParametrsView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
            self.customAlert = nil
        }
    }
    
    
}

//MARK: Animation

extension TimerWorkoutViewController {
    
    private func animationCircular() {
        
        let center = CGPoint(x: imageWorkout.frame.width / 2,
                             y: imageWorkout.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: imageWorkout.frame.width / 3,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        imageWorkout.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

extension TimerWorkoutViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            imageWorkout.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 30),
            imageWorkout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            imageWorkout.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            imageWorkout.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            timerLabel.centerXAnchor.constraint(equalTo: imageWorkout.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: imageWorkout.centerYAnchor),
            
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
