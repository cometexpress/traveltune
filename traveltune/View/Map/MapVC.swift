//
//  MapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

final class MapVC: BaseViewController<MapView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            self?.mainView.scrollView.setZoomScale(2, animated: true)
        }
    }
    
    override func configureVC() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.background
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = Strings.TabMap.title
    }
}
