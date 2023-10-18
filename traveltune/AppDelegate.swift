//
//  AppDelegate.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        NotificationManager.notificationCenter.delegate = self
        
        UIView.appearance().backgroundColor = .clear
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()  // 네비바 라인 제거 및 기존 백그라운드 색 사용
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 포그라운드에서 알림이 뜨도록 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 포그라운드일 때 옵션설정
        completionHandler([.sound, .badge, .banner, .list])
    }
    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        let sceneDelegate = windowScene?.delegate as? SceneDelegate
//        
//        let appState = UIApplication.shared.applicationState
//        let value = response.notification.request.identifier
//        
//        switch NotificationManager.identifier(rawValue: value) {
//        case .schedule:
//            switch appState {
//            case .active, .inactive:
//                print("스케줄 알림 포그라운드")
//                guard let vc = sb.instantiateViewController(withIdentifier: MainVC.identifier) as? MainVC else { return }
//                sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: vc)
//                sceneDelegate?.window?.makeKeyAndVisible()
//            case .background:
//                print("스케줄 알림 백그라운드")
//            default:
//                print("error")
//            }
//        case .test:
//            switch appState {
//            case .active, .inactive:
//                print("테스트 알림 포그라운드")
//                guard let vc = sb.instantiateViewController(withIdentifier: SettingVC.identifier) as? SettingVC else { return }
//                
//                sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: vc)
//                sceneDelegate?.window?.makeKeyAndVisible()
//            case .background:
//                print("테스트 알림 백그라운드")
//            default:
//                print("error")
//            }
//        case .none:
//            print("오류")
//        }
//        completionHandler()
//    }
}

