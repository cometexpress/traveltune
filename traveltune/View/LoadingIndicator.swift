//
//  LoadingIndicator.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit

final class LoadingIndicator {
    
    static func show() {
        DispatchQueue.main.async {
//            guard let window = UIApplication.shared.windows.last else { return }
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last else { return }
            
            let indicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                indicatorView = existedView
            } else {
                indicatorView = UIActivityIndicatorView(style: .large)
                indicatorView.frame = window.frame
                indicatorView.color = .txtSecondary
                window.addSubview(indicatorView)
            }
            
            indicatorView.startAnimating()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
//            guard let window = UIApplication.shared.windows.last else { return }
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
