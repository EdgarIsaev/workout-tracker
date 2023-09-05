//
//  NewWorkoutViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 02.03.2023.
//

import UIKit


class NewWorkoutViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .none
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.frame.size = contentSize
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
    private let selectImageLabel = UILabel(text: "Select image")
    
    private lazy var saveButton = GreenButton(text: "SAVE")
    
    private let newWorkoutLabel = UILabel(text: "NEW WORKOUT",
                                          font: .robotoMedium24(),
                                          textColor: .specialGray)
    
    private lazy var closeButton = CloseButton()
    
    private let nameView = NameView()
    private let dateAndRepeatView = DateAndRepeatView()
    private let repsOrTimerView = RepsOrTimerView()
    
    private var imageStack = UIStackView()
    private var stackView = UIStackView()
    
    private var workoutModel = WorkoutModel()
    private let testImage = UIImage(named: "testWorkout")
    
    private let imageCollection = WorkoutImageCollectionView()
    
    private var imageForModel: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addGesture()
        setDefaultImage()
    }
    
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(newWorkoutLabel)
        contentView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        imageCollection.selectImageDelegate = self
        imageStack = UIStackView(arrangedSubViews: [selectImageLabel,
                                                        imageCollection],
                                     axis: .vertical,
                                     spacing: 5)
        stackView = UIStackView(arrangedSubViews: [nameView,
                                                   imageStack,
                                                   dateAndRepeatView,
                                                   repsOrTimerView],
                                axis: .vertical,
                                spacing: 20)
        contentView.addSubview(stackView)
        contentView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        setModel()
        saveModel()
    }
    
    private func setModel() {
        workoutModel.workoutName = nameView.getNameTextFieldText()
        
        workoutModel.workoutDate = dateAndRepeatView.getDateAndRepeat().date
        workoutModel.workoutRepeat = dateAndRepeatView.getDateAndRepeat().isRepeat
        workoutModel.workoutNumberOfDay = dateAndRepeatView.getDateAndRepeat().date.getWeekdayNumber()
        
        workoutModel.workoutSets = repsOrTimerView.sets
        workoutModel.workoutReps = repsOrTimerView.reps
        workoutModel.workoutTimer = repsOrTimerView.timer
        
        
        workoutModel.workoutImage = imageForModel
    }
    
    private func saveModel() {
        let text = nameView.getNameTextFieldText()
        let count = text.filter { $0.isNumber || $0.isLetter }.count
        
        if count != 0 &&
            workoutModel.workoutImage != nil &&
            workoutModel.workoutSets != 0 &&
            (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            RealmManager.shared.saveWorkoutModel(workoutModel)
            createNotification()
            presentSimpleAlert(title: "Success", message: nil)
            workoutModel = WorkoutModel()
            resetValues()
        } else {
            presentSimpleAlert(title: "Error", message: "Enter all parameters")
        }
    }
    
    private func resetValues() {
        nameView.resetTextFieldName()
        dateAndRepeatView.resetDateAndRepeat()
        repsOrTimerView.resetRepsOrTimer()
        
    }
    
    private func addGesture() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hydeKeybord))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(hydeKeybord))
        swipeScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeScreen)
    }
    
    @objc private func hydeKeybord() {
        view.endEditing(true)
    }
    
    private func createNotification() {
        let notifications = Notifications()
        let stringDate = workoutModel.workoutDate.yyyyMMddFromDate()
        notifications.scheduleDateNotification(date: workoutModel.workoutDate, id: "workout" + stringDate)
    }
    
    private func setDefaultImage() {
        imageCollection.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        guard let defaultImageData = UIImage(named: "Default")?.pngData() else { return }
        imageForModel = defaultImageData
    }
}

//MARK: SelectImageProtocol

extension NewWorkoutViewController: SelectImageProtocol {
    func selectImage(imageName: Data) {
        imageForModel = imageName
    }
}

//MARK: SetConstraints

extension NewWorkoutViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            newWorkoutLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: newWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            nameView.heightAnchor.constraint(equalToConstant: 60),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 120),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 340),
            imageStack.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 55),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
            
            
        ])
    }
}
