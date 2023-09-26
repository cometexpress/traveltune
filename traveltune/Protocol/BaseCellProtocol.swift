//
//  BaseCellProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import Foundation

protocol BaseCellProtocol {
    associatedtype T
    func configureHierarchy()
    func configureLayout()
    func configCell(row: T)
}
