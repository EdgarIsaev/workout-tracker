//
//  ProfileCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 22.03.2023.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let workoutNumberLabel = UILabel(text: "180",
                                             font: .robotoBold48(),
                                             textColor: .white)
    
    private let workoutImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "PushUps")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let workoutLabel = UILabel(text: "Push Ups",
                                       font: .robotoBold24(),
                                       textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialGreen
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(workoutLabel)
        workoutLabel.textAlignment = .center
        addSubview(workoutImage)
        addSubview(workoutNumberLabel)
    }
    
    public func cellConfigure(model: ResultWorkout, index: Int) {
        
        if index % 4 == 0 || index % 4 == 3 {
            backgroundColor = .specialGreen
        }
        else {
            backgroundColor = .specialDarkYellow
        }
        
        workoutLabel.text = model.name
        workoutNumberLabel.text = "\(model.result)"
        
        guard let data = model.imageData else { return }
        let image = UIImage(data: data)
        
        workoutImage.image = image?.withRenderingMode(.alwaysTemplate)
    }
}

extension ProfileCollectionViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            workoutLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            workoutLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            workoutLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            workoutLabel.heightAnchor.constraint(equalToConstant: 25),
            
            workoutImage.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 10),
            workoutImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            workoutImage.widthAnchor.constraint(equalToConstant: frame.height / 2),
            workoutImage.heightAnchor.constraint(equalToConstant: frame.height / 2),
            
            workoutNumberLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 10),
            workoutNumberLabel.leadingAnchor.constraint(equalTo: workoutImage.trailingAnchor, constant: 10),
            workoutNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            workoutNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
