//
//  CheckBoxView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import UIKit
import SnapKit

protocol CheckBoxDelegate: AnyObject {
    func checkBoxClicked(isChecked: Bool)
}

final class CheckBoxView: UIView {
    
    weak var delegate: CheckBoxDelegate?
    
    private var isChecked = false
    
    private let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
    
    private lazy var checkImageView = UIImageView().setup { view in
        view.image = .square.withConfiguration(configuration).withTintColor(.txtPrimary, renderingMode: .alwaysOriginal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkViewClicked))
        addGestureRecognizer(tap)
        addSubview(checkImageView)
        
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    @objc func checkViewClicked() {
        self.isChecked = !isChecked
        delegate?.checkBoxClicked(isChecked: isChecked)
    }
    
    func updateCheckboxImage(checked: Bool) {
        if checked {
            checkImageView.image = .checkmarkSquare.withConfiguration(configuration).withTintColor(.txtPrimary, renderingMode: .alwaysOriginal)
        } else {
            checkImageView.image = .square.withConfiguration(configuration).withTintColor(.txtPrimary, renderingMode: .alwaysOriginal)
        }
    }
}
