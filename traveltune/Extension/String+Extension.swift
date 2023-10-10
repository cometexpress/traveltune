//
//  String+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: [CVarArg] = []) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    mutating func firstCharUppercased() -> String {
        let upper = self[self.startIndex].uppercased()
        self.removeFirst(1)
        self = upper + self
        return self
    }
}
