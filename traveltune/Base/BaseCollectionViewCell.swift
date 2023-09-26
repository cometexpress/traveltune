//
//  BaseCollectionViewCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

class BaseCollectionViewCell<View, Model>: UICollectionViewCell, BaseCellProtocol {
    
    typealias T = Model
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(row: T) {}
}
