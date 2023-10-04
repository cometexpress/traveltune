//
//  RegionButton.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import UIKit

final class RegionButton: UIButton {
    
    private var config = UIButton.Configuration.filled()
    
    private var title = ""
    private var type: RegionType = .seoul
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, type: RegionType) {
        self.init(frame: .zero)
        self.type = type
        var attString = AttributedString(title)
        attString.font = .monospacedSystemFont(ofSize: 8, weight: .light)
        config.attributedTitle = attString
        configuration = config
    }
    
    func defaultBackground() {
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.txtSecondary.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        config.contentInsets = .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        config.baseBackgroundColor = .koreaMapTint
        config.baseForegroundColor = .txtPrimary
        configuration = config
    }
    
    func selectedBackground() {
        layer.cornerRadius = 8
        clipsToBounds = true
        config.contentInsets = .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        config.baseBackgroundColor = .txtSecondary
        config.baseForegroundColor = .txtPrimaryReversal
        configuration = config
    }

}
