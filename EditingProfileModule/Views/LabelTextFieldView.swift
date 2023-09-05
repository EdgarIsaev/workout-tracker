//
//  LabelTextFieldView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 23.03.2023.
//

import UIKit

class LabelTextFieldView: UIView {
    
    private let textField = SameTextField()
    
    private let label = UILabel(text: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init()
        self.label.text = text
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(textField)
    }
    
    public func getTextFieldText() -> String {
        guard let text = textField.text else { return ""}
        return text
    }
    
    public func getIntFromString() -> Int {
        guard let stringText = textField.text else { return 0}
        guard let intText = Int(stringText) else { return 0 }
        return intText
    }
    
    public func fillingTextField(text: String) {
        textField.text = text
    }
}

extension LabelTextFieldView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.heightAnchor.constraint(equalToConstant: 15),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
