//
//  BaseView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

class BaseView: UIView {
    
    var isShowDeinit: Bool { false }
    
    var viewBg: UIColor { .background }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = viewBg
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    
    deinit {
        if isShowDeinit {
            print("[",String(describing: type(of: self)), "] / [deinit]")
        }
    }
}
