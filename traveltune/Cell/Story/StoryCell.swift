//
//  StoryCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit
import SnapKit

final class StoryCell: BaseCollectionViewCell<String> {
    
    let testLabel = UILabel().setup { view in
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 20)
    }
   
    override func configureHierarchy() {
        contentView.addSubview(testLabel)
    }
    
    override func configureLayout() {
        testLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
    }
    
    override func configCell(row: String) {
        testLabel.text = row
    }
    
    
}
