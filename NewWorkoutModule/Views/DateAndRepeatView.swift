//
//  DateAndRepeatView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 02.03.2023.
//

import UIKit

class DateAndRepeatView: UIView {
    
    private let repeatLabel = UILabel(text: "Repeat every 7 days",
                                      font: .robotoMedium18(),
                                      textColor: .specialGray)
    
    private let dateLabel = UILabel(text: "Date",
                                    font: .robotoMedium18(),
                                    textColor: .specialGray)
    
    private let repeatSwitch: UISwitch = {
       let repeatSwitch = UISwitch()
        repeatSwitch.onTintColor = .specialGreen
        repeatSwitch.isOn = true
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repeatSwitch
    }()
    
    private let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .specialGreen
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .specialBrown
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    private let dateAndRepeatLabel = UILabel(text: "Date and repeat")
    
    private var dateStackView = UIStackView()
    private var repeatStackView = UIStackView()
    
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
        
        addSubview(dateAndRepeatLabel)
        addSubview(backgroundView)
        dateStackView = UIStackView(arrangedSubViews: [dateLabel,
                                                       datePicker],
                                    axis: .horizontal,
                                    spacing: 10)
        dateStackView.distribution = .equalSpacing
        repeatStackView = UIStackView(arrangedSubViews: [repeatLabel,
                                                         repeatSwitch],
                                      axis: .horizontal,
                                      spacing: 10)
        repeatStackView.distribution = .equalSpacing
        addSubview(dateStackView)
        addSubview(repeatStackView)
    }
    
    public func getDateAndRepeat() -> (date: Date, isRepeat: Bool) {
        (datePicker.date, repeatSwitch.isOn)
    }
    
    public func resetDateAndRepeat() {
        datePicker.date = Date()
        repeatSwitch.isOn = true
    }
}

extension DateAndRepeatView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            dateAndRepeatLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            dateAndRepeatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            dateAndRepeatLabel.heightAnchor.constraint(equalToConstant: 20),
            
            backgroundView.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 5),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            dateStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            dateStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            dateStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            
            repeatStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10),
            repeatStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            repeatStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15)
        ])
    }
}
