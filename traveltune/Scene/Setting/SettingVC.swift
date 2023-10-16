//
//  SettingVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

final class SettingVC: BaseViewController<SettingView, SettingViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = Strings.Setting.title
    }
    
    func configureVC() {
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
        navigationItem.backButtonDisplayMode = .minimal
        
        mainView.settingVCProtocol = self
    }
    
    func bindViewModel() {
        
    }
}

extension SettingVC: SettingVCProtocol {
    
    func didSelectItemAt(item: SettingItem) {
        switch item.title {
        case Strings.Setting.settingAudioGuideItem01:
            let vc = FavoriteAudioGuideVC(
                viewModel: FavoriteAudioGuideViewModel(
                    localFavoriteStoryRepository: LocalFavoriteStoryRepository()
                )
            )
            vc.hidesBottomBarWhenPushed = true
            vc.naviTitle = item.title
            navigationController?.pushViewController(vc, animated: true)
        default:
            print(item.title)
        }
    }
}
