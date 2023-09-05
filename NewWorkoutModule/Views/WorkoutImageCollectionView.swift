//
//  WorkoutImageCollectionView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 15.03.2023.
//

import UIKit

protocol SelectImageProtocol: AnyObject {
    func selectImage(imageName: Data)
}

class WorkoutImageCollectionView: UICollectionView {
    
    weak var selectImageDelegate: SelectImageProtocol?
    
    let imageArray = ["Default", "Biceps", "PullUps", "PushUps", "Squats", "Triceps"]
    let imageDataArray = [UIImage(named: "Default"),
                          UIImage(named: "Biceps"),
                          UIImage(named: "PullUps"),
                          UIImage(named: "PushUps"),
                          UIImage(named: "Squats"),
                          UIImage(named: "Triceps")]
    
    private let collectionLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        
        setupLayout()
        configure()
        setDelegate()
        register(WorkoutImageCollectionCell.self, forCellWithReuseIdentifier: WorkoutImageCollectionCell.idWorkoutImageCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        collectionLayout.minimumLineSpacing = 3
        collectionLayout.scrollDirection = .horizontal
    }
    
    private func configure() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        bounces = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegate() {
        
        delegate = self
        dataSource = self
    }
    
    private func defaultSelected() {
    }
}

//MARK: UICollectionViewDataSource

extension WorkoutImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutImageCollectionCell.idWorkoutImageCell,
                                                            for: indexPath) as? WorkoutImageCollectionCell else { return UICollectionViewCell() }
        
        guard let imageCell = imageDataArray[indexPath.row] else { return UICollectionViewCell() }
        cell.GetImageCell(image: imageCell)
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension WorkoutImageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 4,
               height: collectionView.frame.height)
    }
}

//MARK: UICollectionViewDelegate

extension WorkoutImageCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageData = imageDataArray[indexPath.row]?.pngData() else { return }
        selectImageDelegate?.selectImage(imageName: imageData)
    }
}
