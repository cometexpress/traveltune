//
//  SearchTextField.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit

final class SearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var textPadding = UIEdgeInsets(
        top: 4,
        left: 16,
        bottom: 4,
        right: 4
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    func config() {
        attributedPlaceholder = NSAttributedString(
            string: Strings.Common.searchPlaceHolder,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.txtDisabled]
        )
        textColor = .txtPrimary
        font = .monospacedSystemFont(ofSize: 16, weight: .regular)
        backgroundColor = .backgroundPlaceholder
        clipsToBounds = true
        layer.cornerRadius = 8
        clearButtonMode = .whileEditing
        returnKeyType = .search
        addDoneOnKeyboardWithTarget(self, action: #selector(toolBarDoneClicked), titleText: nil)
        //        view.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(keyboardDoneClicked))
    }
    
    @objc private func toolBarDoneClicked() {
        self.resignFirstResponder()
    }
}
