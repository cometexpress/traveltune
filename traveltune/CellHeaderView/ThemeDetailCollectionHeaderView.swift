//
//  ThemeDetailCollectionHeaderView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit
import SnapKit

final class ThemeDetailCollectionHeaderView: UICollectionReusableView {
    
    let thumbImageView = CircleImageView(frame: .zero).setup { view in
        view.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        backgroundColor = .white
        addSubview(thumbImageView)
    }
    
    private func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(self.snp.height).multipliedBy(0.5)
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    func configView() {
        thumbImageView.image = .themeEastSea
    }
}
