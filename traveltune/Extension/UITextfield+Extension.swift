//
//  UITextfield+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit

extension UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
