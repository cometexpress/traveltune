//
//  Array+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/19.
//

import Foundation

extension Array where Element: Numeric {
  func sumOfSelf() -> Element {
    return self.reduce(0, +)
  }
}
