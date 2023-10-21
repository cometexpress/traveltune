//
//  AlarmSettingVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/20.
//

import UIKit

final class AlarmSettingVC: BaseViewController<AlarmSettingView, AlarmSettingViewModel> {
    
    var naviTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = naviTitle
    }
    
    func configureVC() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        
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
        
        mainView.baseNotiSwicth.addTarget(self, action: #selector(baseSwitchClicked), for: .valueChanged)
        mainView.requsetNotiPermissionButton.addTarget(self, action: #selector(requestPermissionButtonClicked), for: .touchUpInside)
    }
    
    func bindViewModel() {
        // 노티매니저의 상태를 바인드 해주고 있음.
        // 씬딜리게이트에서 값 변화 주는중
        NotificationManager.shared.notificationStatus.bind { [weak self] status in
            DispatchQueue.main.async {
                guard let self else { return }
                switch status {
                case .notiInit: Void()
                case .enabled:
                    print("알림 권한 허용 / 사용 가능")
                    self.mainView.baseNotiContainerView.alpha = 1
                    self.mainView.baseNotiSwicth.isUserInteractionEnabled = true
                    self.mainView.requsetNotiPermissionButton.isHidden = true
                    self.mainView.notificationGuideLabel.isHidden = true
                    
                    // 노티매니저에서 checkNotiPermission 실행중 UserDefaults 값 업데이트
                    if UserDefaults.notificationStatus {
                        self.baseAlarmStatus(isOn: true)
                    } else {
                        self.baseAlarmStatus(isOn: false)
                    }
                    
                case .disabled:
                    print("알림 사용안함")
                    self.mainView.baseNotiContainerView.alpha = 1
                    self.mainView.baseNotiSwicth.isUserInteractionEnabled = true
                    self.mainView.requsetNotiPermissionButton.isHidden = true
                    self.mainView.notificationGuideLabel.isHidden = true
                    self.baseAlarmStatus(isOn: false)
                    self.mainView.baseNotiSwicth.setOn(false, animated: false)
                case .denied:
                    print("알림 권한 거부")
                    self.mainView.baseNotiContainerView.alpha = 0.5
                    self.mainView.baseNotiSwicth.isUserInteractionEnabled = false
                    self.mainView.requsetNotiPermissionButton.isHidden = false
                    self.mainView.notificationGuideLabel.isHidden = false
                    self.baseAlarmStatus(isOn: false)
                    self.mainView.baseNotiSwicth.setOn(false, animated: false)
                }
            }
        }
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func baseSwitchClicked(sender: UISwitch) {
        baseAlarmStatus(isOn: sender.isOn)
    }
    
    @objc private func requestPermissionButtonClicked(sender: UISwitch) {
        showNotiSettingAlert()
    }
    
    private func baseAlarmStatus(isOn: Bool) {
        if isOn {
            UserDefaults.notificationStatus = true
            viewModel?.useNotifications()
            mainView.baseNotiSwicth.setOn(true, animated: false)
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UserDefaults.notificationStatus = false
            viewModel?.disableNotifications()
            mainView.baseNotiSwicth.setOn(false, animated: false)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    private func showNotiSettingAlert() {
        showAlert(
            title: Strings.Common.notificationServices,
            msg: Strings.Common.notificationServicesGuide,
            ok: Strings.Common.move,
            no: Strings.Common.cancel
        ) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
    }
}

extension AlarmSettingVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
