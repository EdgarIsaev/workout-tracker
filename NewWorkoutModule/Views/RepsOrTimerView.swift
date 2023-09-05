//
//  RepsOrTimerView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 02.03.2023.
//

import UIKit

class RepsOrTimerView: UIView {
    
    private let setsView = SliderView(name: "Sets", minimumValue: 0, maximumValue: 10, type: .sets)
    private let repsView = SliderView(name: "Reps", minimumValue: 0, maximumValue: 50, type: .reps)
    private let timerView = SliderView(name: "Timer", minimumValue: 0, maximumValue: 600, type: .timer)
    
    private let backgroundView: UIView = {
       let background = UIView()
        background.backgroundColor = .specialBrown
        background.layer.cornerRadius = 10
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    private let repsOrTimerLabel = UILabel(text: "Reps or timer")
    private let chooseLabel = UILabel(text: "Choose repeat or timer")
    
    private var stackView = UIStackView()
    
    public var (sets, reps, timer) = (0, 0, 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraint()
        setDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(repsOrTimerLabel)
        addSubview(backgroundView)
        addSubview(chooseLabel)
        stackView = UIStackView(arrangedSubViews: [setsView,
                                                   chooseLabel,
                                                   repsView,
                                                   timerView],
                                axis: .vertical,
                                spacing: 20)
        addSubview(stackView)
    }
    
    private func setDelegates() {
        setsView.delegate = self
        repsView.delegate = self
        timerView.delegate = self
    }
    
    public func resetRepsOrTimer() {
        setsView.resetValues()
        repsView.resetValues()
        timerView.resetValues()
    }
}

//MARK: SliderViewProtocol

extension RepsOrTimerView: SliderViewProtocol {
    func changeValue(type: SliderTypes, value: Int) {
        switch type {
            
        case .sets:
            sets = value
        case .reps:
            reps = value
            repsView.isActive = true
            timerView.isActive = false
            timer = 0
        case .timer:
            timer = value
            timerView.isActive = true
            repsView.isActive = false
            reps = 0
        }
    }
    
}

//MARK: SetConstraint

extension RepsOrTimerView {
    private func setConstraint() {
        NSLayoutConstraint.activate([
        
            repsOrTimerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            repsOrTimerLabel.heightAnchor.constraint(equalToConstant: 20),
            
            backgroundView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 5),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15)
        ])
    }
}
