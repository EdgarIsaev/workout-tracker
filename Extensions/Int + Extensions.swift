//
//  Int + Extensions.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 07.03.2023.
//

import Foundation

extension Int {
    
    func getTimeFromSeconds() -> String {
        
        if self % 60 == 0 {
            return "\(self / 60) min"
        }
        if self / 60 == 0 {
            return "\(self % 60) sec"
        }
        return "\(self / 60) min \(self % 60) sec"
    }
    
    func convertSeconds() -> (Int, Int) {
        let min = self / 60
        let sec = self % 60
         return(min, sec)
    }
    
    func setZeroForSecond() -> String {
        Double(self) / 10.0 < 1 ? "0\(self)" : "\(self)"
    }
    
    func convertSecondsToString() -> String {
        let min = self / 60
        let sec = self % 60
        let time = "\(min):\(sec.setZeroForSecond())"
         return time
    }
}
