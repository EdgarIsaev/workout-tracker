//
//  Date + Extensions.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 09.03.2023.
//

import Foundation

extension Date {
    
    func getWeekdayNumber() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }
    
    func localDate() -> Date {
        let timeZoneOffSet = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffSet), to: self) ?? Date()
        return localDate
    }
    
    func getWeekArray() -> [[String]] {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "EEEEEE"
        let calendar = Calendar.current
        
        var weekArray: [[String]] = [[], []]
        
        for index in -6...0 {
            let date = calendar.date(byAdding: .day, value: index, to: self) ?? Date()
            let day = calendar.component(.day, from: date)
            weekArray[1].append("\(day)")
            let weekday = formatter.string(from: date)
            weekArray[0].append(weekday)
        }
        return weekArray
    }
    
    func offSetDay(day: Int) -> Date {
        let offSetDay = Calendar.current.date(byAdding: .day, value: -day, to: self) ?? Date()
        return offSetDay
    }
    
    func offSetMonth(month: Int) -> Date {
        let offSetDate = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return offSetDate
    }
    
    func startEndDate() -> (start: Date, end: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let calendar = Calendar.current
//        let day = calendar.component(.day, from: self)
//        let month = calendar.component(.month, from: self)
//        let year = calendar.component(.year, from: self)
//        let dateStart = formatter.date(from: "\(year)/\(month)/\(day)") ?? Date()
        let stringDate = formatter.string(from: self)
        let totalDate = formatter.date(from: stringDate) ?? Date()
        
        let local = totalDate.localDate()
        let dateEnd: Date = {
            let components = DateComponents(day: 1)
            return calendar.date(byAdding: components, to: local) ?? Date()
        }()
        return (local, dateEnd)
    }
    
    func yyyyMMddFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: self)
        return date
    }
}
