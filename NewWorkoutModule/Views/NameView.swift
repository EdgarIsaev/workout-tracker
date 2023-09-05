//
//  NameView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 02.03.2023.
//

import UIKit


class NameView: UIView {
    
    private let nameTextField = SameTextField()
    
    private let nameLabel = UILabel(text: "Name")
    
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
        
        addSubview(nameLabel)
        addSubview(nameTextField)
        nameTextField.delegate = self
    }
    
    public func getNameTextFieldText() -> String {
        guard let text = nameTextField.text else { return "" }
        return text
    }
    
    public func resetTextFieldName() {
        nameTextField.text = ""
    }
}

//MARK: UITextFieldDelegate

extension NameView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension NameView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            nameTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
