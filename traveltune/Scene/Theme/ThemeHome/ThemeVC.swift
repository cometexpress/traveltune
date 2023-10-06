//
//  ThemeVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import Hero

final class ThemeVC: BaseViewController<ThemeView, ThemeViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
        
//        Network.shared.requestVisitorInfo(
//            api: .checkVisitorsInMetro(request: RequestCheckVisitorsInMetro(
//                pageNo: "1",
//                numOfRows: "10",
//                startYmd: "20210513",
//                endYmd: "20210513")
//            ), type: ResponseCheckVisitorsInMetros.self) { response in
//                switch response {
//                case .success(let success):
//                    print(success)
//                case .failure(let failure):
//                    print(failure)
//                }
//            }
        
    }
    
    @objc func searchButtonClicked() {
        let vc = SearchVC(viewModel: SearchViewModel(localSearchKeywordRepository: LocalSearchKeywordRepository()))
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func bindViewModel() {
        viewModel?.themes.bind { [weak self] themes in
            self?.mainView.pagerView.reloadData()
        }
        
        viewModel?.fetchThemes()
    }
    
    func configureVC() {
        mainView.hero.isEnabled = true
        mainView.themeVCProtocol = self
        mainView.viewModel = viewModel
        
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .magnifyingglass.withTintColor(.txtSecondary, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(searchButtonClicked)
        )
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()  // 네비바 라인 제거 및 기존 백그라운드 색 사용
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            NSAttributedString.Key.font: UIFont(name: Constant.Fonts.logo, size: 12)!
        ]
        navigationController?.navigationBar.topItem?.title = Strings.Common.logoTitle
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
}

extension ThemeVC: ThemeVCProtocol {
    
    func moveDetailThemeClicked(theme: ThemeStory) {
        
        let vc = ThemeDetailVC(
            viewModel: ThemeDetailViewModel(
                localTravelSpotRepository: LocalTravelSpotRepository(),
                localThemeStoryRepository: LocalThemeStoryRepository(),
                localFavoriteStoryRepository: LocalFavoriteStoryRepository(),
                storyRepository: StoryRepository()
            )
        )
        vc.hero.isEnabled = true
        vc.themeStory = theme
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
