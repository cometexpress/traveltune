//
//  DetailMapSpotHeaderView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation
import UIKit
import SnapKit

final class DetailMapSpotHeaderView: UICollectionReusableView, BaseCellProtocol {
    
    typealias T = Int
    
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(containerView)
    }
    
    func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configCell(row: Int) {
        
    }
}
