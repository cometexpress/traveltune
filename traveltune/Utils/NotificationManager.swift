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
    
    enum identifier: String {
        case weekly
    }

    // 알림 권한
    func authorization(
        completeHandler: @escaping () -> Void
    ) {
        NotificationManager.notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge]) { success, error in
                completeHandler()
            }
    }
    
    func registerMainPush() {
        // 매주 목요일, 20시에 로컬알림 발생시키기
        let content = UNMutableNotificationContent()
        content.title = Constant.productName
        content.body = Strings.Push.localPushMain
        content.badge = 1
        
        var dateComponets = DateComponents()
        dateComponets.weekday = 5           // sunday = 1 ... saturday = 7
        dateComponets.hour = 20             // 24시간 형식 ( ex) 12시, 13시, 23시..)
        
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
