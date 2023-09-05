//
//  WorkoutParametrsView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 18.03.2023.
//

import UIKit

protocol NextSetProtocol: AnyObject {
    
    func nextSetTapped()
    func editingTapped()
}

class WorkoutParametrsView: UIView {
    
    private lazy var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Editing", for: .normal)
        button.titleLabel?.font = .robotoMedium16()
        button.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .specialLightBrown
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT SET", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .specialGray
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let repsLine: UIView = {
       let line = UIView()
        line.backgroundColor = .specialLightBrown
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private let setsLine: UIView = {
       let line = UIView()
        line.backgroundColor = .specialLightBrown
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private let setsNumberLabel = UILabel(text: "1/4",
                                          font: .robotoMedium24(),
                                          textColor: .specialGray)
    
    private let repsOrTimerNumberLabel = UILabel(text: "20",
                                          font: .robotoMedium24(),
                                          textColor: .specialGray)
    
    private let repsOrTimerLabel = UILabel(text: "Reps",
                                    font: .robotoMedium18(),
                                    textColor: .specialGray)
    
    private let setsLabel = UILabel(text: "Sets",
                                    font: .robotoMedium18(),
                                    textColor: .specialGray)
    
    private let nameLabel = UILabel(text: "Name",
                                    font: .robotoMedium24(),
                                    textColor: .specialGray)
    
    
    private var setsStack = UIStackView()
    private var repsStack = UIStackView()
    
    weak var cellNextSetDelegate: NextSetProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        nameLabel.textAlignment = .center
        
        addSubview(nameLabel)
        let stackViewSets = UIStackView(arrangedSubViews: [setsLabel, setsNumberLabel],
                                        axis: .horizontal,
                                        spacing: 10)
        stackViewSets.distribution = .equalSpacing
        setsStack = UIStackView(arrangedSubViews: [stackViewSets, setsLine],
                                axis: .vertical,
                                spacing: 2)
        addSubview(setsStack)
        let stackViewReps = UIStackView(arrangedSubViews: [repsOrTimerLabel, repsOrTimerNumberLabel],
                                        axis: .horizontal,
                                        spacing: 10)
        stackViewReps.distribution = .equalSpacing
        repsStack = UIStackView(arrangedSubViews: [stackViewReps, repsLine],
                                axis: .vertical,
                                spacing: 2)
        addSubview(repsStack)
        addSubview(editingButton)
        addSubview(nextSetButton)
    }
    
    @objc private func editingButtonTapped() {
        cellNextSetDelegate?.editingTapped()
    }
    @objc private func nextSetButtonTapped() {
        cellNextSetDelegate?.nextSetTapped()
    }
    
    public func refreshLabels(model: WorkoutModel, numberOfSet: Int) {
        nameLabel.text = model.workoutName
        setsNumberLabel.text = "\(numberOfSet)/\(model.workoutSets)"
        repsOrTimerNumberLabel.text = "\(model.workoutReps)"
    }
}

//MARK: SetConstraints

extension WorkoutParametrsView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            setsLine.heightAnchor.constraint(equalToConstant: 1),
            repsLine.heightAnchor.constraint(equalToConstant: 1),
            
            setsStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            setsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            setsStack.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.088),
            
            repsStack.topAnchor.constraint(equalTo: setsStack.bottomAnchor, constant: 20),
            repsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            repsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            repsStack.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.088),
            
            editingButton.topAnchor.constraint(equalTo: repsStack.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editingButton.widthAnchor.constraint(equalToConstant: 75),
            editingButton.heightAnchor.constraint(equalToConstant: 20),
            
            nextSetButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 10),
            nextSetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextSetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextSetButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
