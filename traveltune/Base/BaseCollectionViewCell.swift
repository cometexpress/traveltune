//
//  BaseCollectionViewCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

class BaseCollectionViewCell<T>: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configCell(row: T) {}
}
