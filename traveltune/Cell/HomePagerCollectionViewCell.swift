//
//  HomePagerCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit
import SnapKit
import FSPagerView

final class HomePagerCollectionViewCell: FSPagerViewCell, BaseCellProtocol {
    
    typealias Model = String
    
    private let themeLabel = UILabel().setup { view in
        view.numberOfLines = 1
        view.textColor = .txtPrimary
        view.textAlignment = .center
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(themeLabel)
    }
    
    func configureLayout() {
        themeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configCell(row: String) {
        themeLabel.text = row
    }
}
