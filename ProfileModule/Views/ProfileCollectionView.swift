//
//  ProfileCollectionView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 22.03.2023.
//

import UIKit

struct ResultWorkout {
    let name: String
    let result: Int
    let imageData: Data?
}

class ProfileCollectionView: UICollectionView {
    
    private let idCollectionCell = "idCollectionCell"
    
    private let collectionLayout = UICollectionViewFlowLayout()
    
    private var resultWorkout = [ResultWorkout]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        
        configure()
        setDelegates()
        setupLayout()
        register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: idCollectionCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        collectionLayout.minimumInteritemSpacing = 10
        collectionLayout.scrollDirection = .horizontal
    }
    
    private func configure() {
        backgroundColor = .specialBackground
        bounces = false
        showsHorizontalScrollIndicator = false
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegates() {
        dataSource = self
        delegate = self
    }
    
    private func getWorkoutsNames() -> [String] {
        var nameArray = [String]()
        
        let allWorkouts = RealmManager.shared.getResultsWorkoutModel()
        
        for workoutModel in allWorkouts {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    func getWorkoutResults() {
        let nameArray = getWorkoutsNames()
        let workoutArray = RealmManager.shared.getResultsWorkoutModel()
        
        for name in nameArray {
            let predicate = NSPredicate(format: "workoutName = '\(name)'")
            let filtredArray = workoutArray.filter(predicate).sorted(byKeyPath: "workoutName")
            var result = 0
            var image: Data?
            filtredArray.forEach { model in
                result += model.workoutReps * model.workoutSets
                image = model.workoutImage
            }
            let resultModel = ResultWorkout(name: name, result: result, imageData: image)
            resultWorkout.append(resultModel)
        }
    }
    
    func reloadCollection() {
        resultWorkout = [ResultWorkout]()
        getWorkoutResults()
        reloadData()
    }
}

//MARK: UICollectionViewDataSource

extension ProfileCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultWorkout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCollectionCell, for: indexPath) as? ProfileCollectionViewCell else {
            return  UICollectionViewCell()
        }
        
        let model = resultWorkout[indexPath.row]
        cell.cellConfigure(model: model, index: indexPath.row)
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension ProfileCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width * 0.485,
               height: collectionView.frame.width * 0.339)
    }
}

//MARK: UICollectionViewDelegate

extension ProfileCollectionView: UICollectionViewDelegate {
    
}
