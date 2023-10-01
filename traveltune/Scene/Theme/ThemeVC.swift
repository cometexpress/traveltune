//
//  ThemeVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import Hero

final class ThemeVC: BaseViewController<ThemeView> {
    
    private let viewModel = ThemeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("검색버튼 클릭")
    }
    
    override func configureVC() {
        mainView.hero.isEnabled = true
        mainView.themeVCProtocol = self
        mainView.viewModel = viewModel
        
        viewModel.themes.bind { [weak self] themes in
            self?.mainView.pagerView.reloadData()
        }
        
        viewModel.fetchThemes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .magnifyingglass.withTintColor(.txtSecondary, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(searchButtonClicked)
        )
        
        navigationController?.navigationBar.topItem?.title = Strings.Common.logoTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            NSAttributedString.Key.font: UIFont(name: Constant.Fonts.logo, size: 12)!
        ]
    }
}

extension ThemeVC: ThemeVCProtocol {
    
    func moveDetailThemeClicked(theme: ThemeStory) {
        let vc = ThemeDetailVC()
        vc.hero.isEnabled = true
        vc.themeStory = theme
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
