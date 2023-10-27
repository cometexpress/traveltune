//
//  LoadingIndicator.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit

final class LoadingIndicator {
    
    static func show() {
        LoadingIndicator.hide()
        
        DispatchQueue.main.async {
            let window: UIWindow? = if #available(iOS 15.0, *) {
                UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            } else {
                UIApplication.shared.windows.last
           }
            
            guard let window else { return }
            
            let indicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                indicatorView = existedView
            } else {
                indicatorView = UIActivityIndicatorView(style: .large)
                indicatorView.frame = window.frame
                indicatorView.color = .primary
                window.addSubview(indicatorView)
            }
            indicatorView.startAnimating()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            let window: UIWindow? = if #available(iOS 15.0, *) {
                UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
            } else {
                UIApplication.shared.windows.last
           }
            guard let window else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
