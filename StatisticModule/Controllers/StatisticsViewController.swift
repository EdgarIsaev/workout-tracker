//
//  StatisticsViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 27.02.2023.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    private let statisticsLabel = UILabel(text: "STATISTIC",
                                          font: .robotoMedium24(),
                                          textColor: .specialGray)
    
    private lazy var segmentedControl: UISegmentedControl = {
       let segmentedControl = UISegmentedControl(items: ["Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor: UIColor.specialGray], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let nameTextField = SameTextField()
    
    private let exercisesLabel = UILabel(text: "Exercises")
    private let statisticsTable = StatisticsTableView()
    
    private var workoutArray = [WorkoutModel]()
    private var differenceArray = [DifferenceWorkout]()
    private var filtredArray = [DifferenceWorkout]()
    
    private var isFiltred = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStartScreen()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        statisticsLabel.textAlignment = .center
        
        view.addSubview(statisticsLabel)
        view.addSubview(exercisesLabel)
        view.addSubview(statisticsTable)
        view.addSubview(segmentedControl)
        view.addSubview(nameTextField)
        nameTextField.delegate = self
    }
    
    @objc private func segmentedChange() {
        let dateToday = Date()
        differenceArray = [DifferenceWorkout]()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dateToday.offSetDay(day: 7)
            getDifferenceModel(dateStart: dateStart)
        } else {
            let dateStart = dateToday.offSetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        statisticsTable.setDifferenceArray(array: differenceArray)
        statisticsTable.reloadData()
    }
    
    private func getWorkoutsName() -> [String] {
        var nameArray = [String]()
        
        let allWorkouts = RealmManager.shared.getResultsWorkoutModel()
        
        for workoutModel in allWorkouts {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        } 
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        let dateEnd = Date()
        let nameArray = getWorkoutsName()
        let allWorkouts = RealmManager.shared.getResultsWorkoutModel()
        
        for name in nameArray {
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@",
                                                  [dateStart, dateEnd])
            let filtredArray = allWorkouts.filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            workoutArray = filtredArray.map { $0 }
            
            guard let lastReps = workoutArray.last?.workoutReps,
                  let firstReps = workoutArray.first?.workoutReps,
                  let firstTime = workoutArray.first?.workoutTimer,
                  let lastTime = workoutArray.last?.workoutTimer else {
                return
            }
            let differenceWorkout = DifferenceWorkout(name: name,
                                                      firstReps: firstReps,
                                                      lastReps: lastReps,
                                                      firstTime: firstTime,
                                                      lastTime: lastTime)
            differenceArray.append(differenceWorkout)
        }
        statisticsTable.setDifferenceArray(array: differenceArray)
    }
    
    private func setStartScreen() {
        let dateToday = Date()
        differenceArray = [DifferenceWorkout]()
        if segmentedControl.selectedSegmentIndex == 0 {
            getDifferenceModel(dateStart: dateToday.offSetDay(day: 7))
        }
        else {
            getDifferenceModel(dateStart: dateToday.offSetMonth(month: 1))
        }
        statisticsTable.setDifferenceArray(array: differenceArray)
        statisticsTable.reloadData()
    }
    
    private func filtringWorkouts(text: String) {
        
        for workout in differenceArray {
            
            if workout.name.lowercased().contains(text.lowercased()) {
                filtredArray.append(workout)
            }
        }
    }
}

//MARK: UITextFieldDelegate

extension StatisticsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRang = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRang, with: string)
            
            filtredArray = [DifferenceWorkout]()
            isFiltred = updatedText.count > 0
            filtringWorkouts(text: updatedText)
        }
        
        if isFiltred {
            statisticsTable.setDifferenceArray(array: filtredArray)
        }
        else {
            statisticsTable.setDifferenceArray(array: differenceArray)
        }
        statisticsTable.reloadData()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isFiltred = false
        differenceArray = [DifferenceWorkout]()
        let dateToday = Date().localDate()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            getDifferenceModel(dateStart: dateToday.offSetDay(day: 7))
        }
        else {
            getDifferenceModel(dateStart: dateToday.offSetMonth(month: 1))
        }
        statisticsTable.setDifferenceArray(array: differenceArray)
        statisticsTable.reloadData()
        return true
    }
}

//MARK: SetConstraints

extension StatisticsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            statisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            statisticsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            statisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            statisticsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            segmentedControl.topAnchor.constraint(equalTo: statisticsLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 38),
            
            exercisesLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statisticsTable.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            statisticsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            statisticsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            statisticsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
