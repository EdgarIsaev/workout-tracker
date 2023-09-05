//
//  OnboardingCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 05.05.2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let topLabel = UILabel(font: .robotoBold24(), textColor: .specialGreen)
    
    private let bottomLabel = UILabel(font: .robotoMedium16(), textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstrainrs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialGreen
        
        addSubview(backgroundImageView)
        topLabel.textAlignment = .center
        addSubview(topLabel)
        bottomLabel.textAlignment = .center
        bottomLabel.numberOfLines = 4
        addSubview(bottomLabel)
    }
    
    public func cellConfigure(model: OnboardingStruct) {
        topLabel.text = model.topLabel
        bottomLabel.text = model.bottomLabel
        backgroundImageView.image = model.image
    }
}

//MARK: SetConstraints

extension OnboardingCollectionViewCell {
    private func setConstrainrs() {
        NSLayoutConstraint.activate([
        
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            bottomLabel.heightAnchor.constraint(equalToConstant: 85)
        ])
    }
}
