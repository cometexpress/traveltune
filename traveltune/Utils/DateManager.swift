//
//  DateManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    private init() { }
    
    func compareToDateByTheDay(start: String, end: String) -> Int {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = DateFormat.basic.rawValue
        let startDate = dateFormat.date(from: start) ?? Date()
        let endDate = dateFormat.date(from: end) ?? Date()
        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        return days
    }
}

