//
//  Date+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation

extension Date {
    var basic: String {
        return toString(DateFormat.basic.rawValue)
    }
    
    // MARK: - Date -> String
    func toString(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}

enum DateFormat: String {
    case basic = "yyyy-MM-dd"
}
