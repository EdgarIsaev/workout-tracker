//
//  WorkoutImageCollectionCell.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 15.03.2023.
//

import UIKit

class WorkoutImageCollectionCell: UICollectionViewCell {
    
    static let idWorkoutImageCell = "idWorkoutImageCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Biceps")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .specialDarkGreen
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let backView: UIView = {
       let backView = UIView()
        backView.backgroundColor = .specialBackground
        backView.layer.cornerRadius = 10
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                backView.backgroundColor = .specialGreen
                imageView.tintColor = .white
            }
            else {
                backView.backgroundColor = .specialBackground
                imageView.tintColor = .specialDarkGreen
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViews() {
        addSubview(backView)
        addSubview(imageView)
    }
    
    public func GetImageCell(image: UIImage) {
        guard let imageData = image.pngData() else { return }
        imageView.image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            
            imageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5)
        ])
    }
}
