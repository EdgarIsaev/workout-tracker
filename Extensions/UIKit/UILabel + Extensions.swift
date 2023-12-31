//
//  UILabel + Extensions.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 26.02.2023.
//

import UIKit


extension UILabel {
    
    convenience init(text: String = "") {
        self.init()
        self.text = text
        self.font = .robotoMedium14()
        self.textColor = .specialLightBrown
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false 
    }
    
    convenience init(text: String = "", font: UIFont?, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
