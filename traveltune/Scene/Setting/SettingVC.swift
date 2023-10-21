//
//  SettingVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import MessageUI

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
    
    private func sendEmail() {
        let receiver = "hyeseong7848@gmail.com"
        let subject = "\(Constant.productName) \(Strings.Common.inquiry)"
        let appVersion = Constant.appVersion
        let osVersion = UIDevice().systemVersion    // 기기의 os 버전
        let message = """
                App Version: \(appVersion)
                iOS Version: \(osVersion)
                
                \(Strings.Common.enterInquiryDetails)
                
                """
        
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([receiver])
            mailVC.setSubject(subject)
            mailVC.setMessageBody(message, isHTML: false)
            present(mailVC, animated: true, completion: nil)
        }
        else {
            showAlert(title: "", msg: Strings.ErrorMsg.errorFailNoEmail, ok: Strings.Common.ok)
        }
    }
    
    private func appVersionCheck() {
        Task {
            let appVer = Constant.appVersion
            let storeVer = try await Constant.getStoreVersion()
            print(appVer)
            print(storeVer)
            
            if !appVer.isEmpty && !storeVer.isEmpty {
                let compareResult = appVer.compare(storeVer, options: .numeric)
                switch compareResult {
                    
                case .orderedAscending:
                    let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(Constant.storeId)"
                    showAlert(title: "알림", msg: "새로운 버전이 나왔어요!", ok: Strings.Common.move) { _ in
                        if let url = URL(string: appStoreOpenUrlString),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                case .orderedDescending:
                    break
                case .orderedSame:
                    break
                }
            } else {
                showToast(msg: Strings.ErrorMsg.errorNetwork)
            }
        }
    }
}

extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true) { [weak self] in
            switch result {
            case .cancelled:
                print("취소")
            case .saved:
                print("임시저장")
            case .sent:
                print("성공")
                self?.showToast(msg: Strings.Common.successSendEmail)
            case .failed:
                self?.showToast(msg: Strings.ErrorMsg.errorFailSendEmail)
            @unknown default:
                print("default")
            }
        }
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
            
        case Strings.Setting.settingNotificationItem01:
            print("알림 상세")
            let vc = AlarmSettingVC(viewModel: AlarmSettingViewModel())
            vc.hidesBottomBarWhenPushed = true
            vc.naviTitle = item.title
            navigationController?.pushViewController(vc, animated: true)
            
        case Strings.Setting.settingTermsItem01:
            print("이용약관")
        case Strings.Setting.settingEtcItem01:
            sendEmail()
        case Strings.Setting.settingEtcItem02:
            print("오픈소스")
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        case Strings.Setting.settingEtcItem03:
            print("앱버전")
            // TODO: 추후 앱 출시 후 테스트 필요
//            appVersionCheck()
        default:
            print(item.title)
        }
    }
}
