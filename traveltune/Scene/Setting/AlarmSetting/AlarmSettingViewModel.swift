//
//  AlarmSettingViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/20.
//

import Foundation
import UserNotifications

final class AlarmSettingViewModel: BaseViewModel {
    
    func useNotifications() {
        NotificationManager.shared.registerMainPush()
    }
    
    func disableNotifications() {
        NotificationManager.shared.removeAllNotification()
    }
}
