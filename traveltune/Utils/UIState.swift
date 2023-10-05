//
//  UIState.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

enum UIState<T> {
    case initValue
    case loading
    case success(data: T)
    case error(msg: String)
}
