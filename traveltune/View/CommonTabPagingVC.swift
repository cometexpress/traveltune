//
//  CommonTabPagingVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import Foundation
import Parchment

final class CommonTabPagingVC: PagingViewController {
    
    var tabTitles: [String] = []
    var tabViewControllers: [UIViewController] = []
    
    override init(options: PagingOptions = PagingOptions()) {
        super.init(options: options)
        config()
    }
    
    convenience init(
        options: PagingOptions = PagingOptions(),
        viewControllers: [UIViewController],
        tabTitles: [String]
    ) {
        self.init(options: options)
        self.tabViewControllers = viewControllers
        self.tabTitles = tabTitles
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        menuBackgroundColor = .background
        menuItemSize = .sizeToFit(minWidth: 100, height: 50)
        menuItemSpacing = 0
        menuItemLabelSpacing = 16
        
        let widthSpacing: CGFloat = 20
        indicatorOptions = .visible(height: 2, zIndex: Int.max, spacing: .init(top: 0, left: widthSpacing, bottom: 0, right: widthSpacing),
                                                         insets: .init(top: 0, left: widthSpacing, bottom: 0, right: widthSpacing))
        indicatorColor = .primary
        borderOptions = .visible(height: 0.5, zIndex: Int.max - 1, insets: .init(top: 0, left: widthSpacing, bottom: 0, right: widthSpacing))
        borderColor = .backgroundPlaceholder
        font = .monospacedSystemFont(ofSize: 14, weight: .light)
        selectedFont = .monospacedSystemFont(ofSize: 14, weight: .regular)
        textColor = .placeholderText
        selectedTextColor = .txtPrimary
    }
}
