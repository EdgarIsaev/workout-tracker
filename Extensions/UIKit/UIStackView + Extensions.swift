//
//  UIStackView + Extensions.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 26.02.2023.
//

import UIKit


extension UIStackView {
    
    convenience init(arrangedSubViews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self .init(arrangedSubviews: arrangedSubViews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
