//
//  UIViewController+Extension.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Toast

extension UIViewController {
    
    func showAlert(
        title: String,
        msg: String,
        ok: String,
        no: String? = nil,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ok, style: .default, handler: handler)
        alert.addAction(okAction)
        if let no {
            let noAction = UIAlertAction(title: no, style: .cancel)
            alert.addAction(noAction)
        }
        present(alert, animated: true)
    }
    
    func showToast(
        msg: String,
        position: ToastPosition = .bottom,
        backgroundColor: UIColor = .black.withAlphaComponent(0.8)
    ) {
        var style = ToastStyle()
        style.messageFont =  .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        style.messageColor = .white
        style.messageAlignment = .center
        style.backgroundColor = backgroundColor
        self.view.makeToast(msg, duration: 2.0, position: position, style: style)
    }
}
