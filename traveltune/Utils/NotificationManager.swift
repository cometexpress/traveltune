//
//  NotificationManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/18.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    static let notificationCenter = UNUserNotificationCenter.current()
    private init() {}
    
    enum NotificationSettingStatus {
        case notiInit
        case enabled
        case disabled
        case denied
    }
    
    enum identifier: String {
        case weekly
    }

    var notificationStatus: Observable<NotificationSettingStatus> = Observable(.notiInit)
    
    // 알림 권한
    func authorization(
        completeHandler: @escaping () -> Void
    ) {
        NotificationManager.notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge]) { isAllow, error in
                completeHandler()
                UserDefaults.notificationStatus = isAllow
            }
    }
    
    func registerMainPush() {
        
        if UserDefaults.notificationStatus {
            // 매주 목요일, 20시에 로컬알림 발생시키기
            let content = UNMutableNotificationContent()
            content.title = Constant.productName
            content.body = Strings.Push.localPushMain
            content.badge = 1
            
            var dateComponets = DateComponents()
            dateComponets.weekday = 5           // sunday = 1 ... saturday = 7
            dateComponets.hour = 20             // 24시간 형식 ( ex) 12시, 13시, 23시..)
            
//            let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponets, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: NotificationManager.identifier.weekly.rawValue,
                content: content,
                trigger: trigger
            )
            
            NotificationManager.notificationCenter.add(request) { error in
                print(error)
            }
        }
    }
    
    func removeNotification(identifiers: [String]) {
        NotificationManager.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func removeAllNotification() {
        NotificationManager.notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func checkNotiPermission() {
        NotificationManager.notificationCenter.getNotificationSettings { [weak self] settings in
            guard (settings.authorizationStatus == .authorized)
                    || (settings.authorizationStatus == .provisional) else {
                self?.notificationStatus.value = .denied
                return
            }
            
            if settings.alertSetting == .enabled {
                // 알림 설정에서 배너가 선택되어있으면 enabled 로 찍힘
                self?.notificationStatus.value = .enabled
                UserDefaults.notificationStatus = true
            } else {
                // 알림 설정에서 배너 선택안되어있으면
                self?.notificationStatus.value = .disabled
            }
        }
    }
}
