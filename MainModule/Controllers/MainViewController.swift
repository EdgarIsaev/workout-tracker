//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 21.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let userPhotoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your name"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.tintColor = .specialDarkGreen
        button.titleEdgeInsets = .init(top: 50,
                                       left: -40,
                                       bottom: 0,
                                       right: 0)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.imageEdgeInsets = .init(top: 0,
                                       left: 21,
                                       bottom: 15,
                                       right: 0)
        button.addShadowOnView()
        button.titleLabel?.font = .robotoMedium12()
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noWorkoutImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "noWorkout")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    private let workoutTodayLabel = UILabel(text: "Workout today")
    private let tableView = MainTableView()
    
    private var workoutArray = [WorkoutModel]()
    
    private var selectDate = Date()
 
    override func viewDidLayoutSubviews() {
        userPhotoImage.layer.cornerRadius = userPhotoImage.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectItem(date: selectDate)
        setupUserParametrs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showOnboarding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        getWeather()
    }
    
    func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(calendarView)
        calendarView.setDelegate(self)
        view.addSubview(userPhotoImage)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
        tableView.mainTableViewDelegate = self
        view.addSubview(noWorkoutImage )
    }
    
    @objc private func addWorkoutButtonTapped() {
        let newWorkoutController = NewWorkoutViewController()
        newWorkoutController.modalPresentationStyle = .fullScreen
        present(newWorkoutController, animated: true)
    }
    
    private func getWorkout(date: Date) {
        let weekday = date.getWeekdayNumber()
        let dateStart = date.startEndDate().start
        let dateEnd = date.startEndDate().end
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnrepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnrepeat])
        
        let resultArray = RealmManager.shared.getResultsWorkoutModel()
        let filtredArray = resultArray.filter(compound).sorted(byKeyPath: "workoutName")
        workoutArray = filtredArray.map { $0 }
    }
    
    private func checkWorkoutToday() {
//        if workoutArray.count == 0 {
//            noWorkoutImage.isHidden = false
//            tableView.isHidden = true
//        }
//        else {
//            noWorkoutImage.isHidden = true
//            tableView.isHidden = false
//        }
        noWorkoutImage.isHidden = !workoutArray.isEmpty
        tableView.isHidden = workoutArray.isEmpty
    }
    
    private func setupUserParametrs() {
        let userArray = RealmManager.shared.getResultsUserModel()
        
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data) else { return }
            
            userPhotoImage.image = image
        }
    }
    
    private func getWeather() {
        NetworkDataFetch.shared.fetchWeather { [weak self] result, error in
            guard let self = self else { return }
            if let model = result {
                print(model)
                
                self.weatherView.updateLabels(model: model)
                
                NetworkImageRequest.shared.requestData(id: model.weather[0].icon) { result in
                    switch result {
                        
                    case .success(let data):
                        self.weatherView.updateImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showOnboarding() {
        let userDefaults = UserDefaults.standard
        let onboardingWasViewed = userDefaults.bool(forKey: "OnboardingWasViewed")
        if onboardingWasViewed == false {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
        }
    }
}

extension MainViewController: MainTableViewProtocol {
    func deleteWorkout(model: WorkoutModel, index: Int) {
        RealmManager.shared.deleteWorkoutModel(model)
        workoutArray.remove(at: index)
        tableView.setWorkoutArray(array: workoutArray)
        tableView.reloadData()
    }
}

//MARK: CalendarViewProtocol

extension MainViewController: CalendarViewProtocol {
    func selectItem(date: Date) {
        getWorkout(date: date)
        selectDate = date
        tableView.setWorkoutArray(array: workoutArray)
        tableView.reloadData()
        checkWorkoutToday()
    }
}

//MARK: WorkoutCellProtocol

extension MainViewController: WorkoutCellProtocol {
    func startButtonTapped(model: WorkoutModel) {
        if model.workoutTimer == 0 {
            let repsWorkoutViewController = RepsWorkoutViewController()
            repsWorkoutViewController.modalPresentationStyle = .fullScreen
            repsWorkoutViewController.setWorkoutModel(model: model)
            present(repsWorkoutViewController, animated: true)
        }
        else {
            let timerWorkoutViewController = TimerWorkoutViewController()
            timerWorkoutViewController.modalPresentationStyle = .fullScreen
            timerWorkoutViewController.setWorkoutModel(model: model)
            present(timerWorkoutViewController, animated: true)
        }
    }
}

extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImage.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImage.heightAnchor.constraint(equalToConstant: 100),
            
            calendarView.topAnchor.constraint(equalTo: userPhotoImage.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImage.trailingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
            
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            noWorkoutImage.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor),
            noWorkoutImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noWorkoutImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noWorkoutImage.heightAnchor.constraint(equalTo: noWorkoutImage.widthAnchor )
        ])
    }
}
