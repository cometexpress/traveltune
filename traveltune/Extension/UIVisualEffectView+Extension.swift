//
//  UIVisualEffectView+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import UIKit

extension UIVisualEffectView {
    
    // UIVisualEffectView 터치 넘겨주도록 설정
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self.contentView ? nil : view
    }
}
