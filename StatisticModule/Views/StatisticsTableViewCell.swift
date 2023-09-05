//
//  StatisticsTableViewCell.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 27.02.2023.
//

import UIKit


class StatisticsTableViewCell: UITableViewCell {
    
    static let idTableViewCell = "idTableViewCell"
    
    private let statisticsNameLabel = UILabel(text: "Biceps",
                                              font: .robotoMedium24(),
                                              textColor: .specialGray
    )
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.text = "+2"
        label.font = .robotoMedium24()
        label.textColor = .specialGreen
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .specialLightBrown
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private let statisticsBeforeLabel = UILabel(text: "Before: 18")
    private let statisticsNowLabel = UILabel(text: "Now: 20")
    private var labelStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(statisticsNameLabel)
        labelStackView = UIStackView(arrangedSubViews: [statisticsBeforeLabel,
                                                        statisticsNowLabel],
                                     axis: .horizontal,
                                     spacing: 10)
        addSubview(labelStackView)
        addSubview(differenceLabel)
        addSubview(lineView)
    }
    
    public func configure(differenceWorkout: DifferenceWorkout) {
        if differenceWorkout.firstTime == 0 && differenceWorkout.lastTime == 0 {
            statisticsNameLabel.text = differenceWorkout.name
            statisticsBeforeLabel.text = "Before: \(differenceWorkout.firstReps)"
            statisticsNowLabel.text = "Now: \(differenceWorkout.lastReps)"
            
            let difference = differenceWorkout.lastReps - differenceWorkout.firstReps
            
            switch difference {
            case ..<0: differenceLabel.text = "\(difference)"
                differenceLabel.textColor = #colorLiteral(red: 0.8351806402, green: 0.7251269221, blue: 0, alpha: 1)
            case 1...: differenceLabel.text = "+\(difference)"
                differenceLabel.textColor = .specialGreen
            default: differenceLabel.text = "\(difference)"
                differenceLabel.textColor = .specialGray
            }
        }
            else {
                
                statisticsNameLabel.text = differenceWorkout.name
                statisticsBeforeLabel.text = "Before: \(differenceWorkout.firstTime.convertSecondsToString())"
                statisticsNowLabel.text = "Now: \(differenceWorkout.lastTime.convertSecondsToString())"
                
                let difference = differenceWorkout.lastTime - differenceWorkout.firstTime
                
                switch difference {
                case ..<0: differenceLabel.text = "\(difference.getTimeFromSeconds())"
                    differenceLabel.textColor = #colorLiteral(red: 0.8351806402, green: 0.7251269221, blue: 0, alpha: 1)
                case 1...: differenceLabel.text = "+\(difference.getTimeFromSeconds())"
                    differenceLabel.textColor = .specialGreen
                default: differenceLabel.text = "\(difference.getTimeFromSeconds())"
                    differenceLabel.textColor = .specialGray
                }
            }
        }
    }



extension StatisticsTableViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            statisticsNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            statisticsNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statisticsNameLabel.heightAnchor.constraint(equalToConstant: 26),
            
            labelStackView.topAnchor.constraint(equalTo: statisticsNameLabel.bottomAnchor, constant: 0),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            differenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            differenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            differenceLabel.heightAnchor.constraint(equalToConstant: 30),
            differenceLabel.leadingAnchor.constraint(equalTo: labelStackView.trailingAnchor, constant: 10),
            
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
