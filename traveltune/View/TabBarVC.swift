//
//  TabBarVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        let viewControllers = [tapVC(type: .home), tapVC(type: .map), tapVC(type: .playlist)]
        setViewControllers(viewControllers, animated: true)
        
        tabBar.backgroundColor = .background
        tabBar.tintColor = .background
        //        tabBar.unselectedItemTintColor = .black
    }
    
    private func tapVC(type: TabType) -> UINavigationController {
        let nav = UINavigationController()
        nav.addChild(type.vc)
        nav.tabBarItem.image = type.icon.withTintColor(.txtDisabled, renderingMode: .alwaysOriginal)
        nav.tabBarItem.selectedImage = type.icon.withTintColor(.txtPrimaryReversal, renderingMode: .alwaysOriginal)
        //        nav.tabBarItem.title = type.title
        return nav
    }
}

extension TabBarVC {
    
    enum TabType {
        case home
        case map
        case playlist
        
        var vc: UIViewController {
            switch self {
            case .home:
                return HomeVC()
            case .map:
                return MapVC()
            case .playlist:
                return PlaylistVC()
            }
        }
        
        
        var icon: UIImage {
            switch self {
            case .home:
                return .tapHome
            case .map:
                return .tapMap
            case .playlist:
                return .tapPlaylist
            }
        }
    }
}
