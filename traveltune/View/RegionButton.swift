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
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        layer.cornerRadius = 8
        clipsToBounds = true
        config.contentInsets = .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        config.baseBackgroundColor = .lightGray
    }
    
    func setRegionTitle(title: String) {
        var attString = AttributedString(title)
        attString.font = .monospacedSystemFont(ofSize: 10, weight: .light)
        attString.foregroundColor = .systemPink
        config.attributedTitle = attString
        configuration = config
    }
}
