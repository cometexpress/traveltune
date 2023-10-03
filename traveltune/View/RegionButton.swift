//
//  RegionButton.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import UIKit

final class RegionButton: UIButton {
    
    private var config = UIButton.Configuration.filled()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultBackground()
//        selectedBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defaultBackground() {
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.txtSecondary.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        config.contentInsets = .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        config.baseBackgroundColor = .koreaMapTint
        config.baseForegroundColor = .txtPrimary
    }
    
    func setRegionTitle(title: String) {
        var attString = AttributedString(title)
        attString.font = .monospacedSystemFont(ofSize: 8, weight: .light)
        config.attributedTitle = attString
        configuration = config
    }
    
    func selectedBackground() {
        layer.cornerRadius = 8
        clipsToBounds = true
        config.contentInsets = .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        config.baseBackgroundColor = .txtSecondary
        config.baseForegroundColor = .txtPrimaryReversal
    }
}
