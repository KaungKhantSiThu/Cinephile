//
//  CinephileApp+AppDelegate.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 20/12/2023.
//

import Foundation
import Environment
import AVFoundation
import SwiftUI
import AppAccount
import CinephileUI

class AppDelegate: NSObject, UIApplicationDelegate {
    weak var routerPath: RouterPath?
    
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        PushNotificationsService.shared.setAccounts(accounts: AppAccountsManager.shared.pushAccounts)
        return true
    }
    
    func application(_: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        PushNotificationsService.shared.pushToken = deviceToken
        Task {
            PushNotificationsService.shared.setAccounts(accounts: AppAccountsManager.shared.pushAccounts)
            await PushNotificationsService.shared.updateSubscriptions(forceCreate: false)
        }
    }
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {}
    
    func application(_: UIApplication, didReceiveRemoteNotification _: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        UserPreferences.shared.reloadNotificationsCount(tokens: AppAccountsManager.shared.availableAccounts.compactMap(\.oauthToken))
        return .noData
    }
    
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification tapped!")

        let userInfo = response.notification.request.content.userInfo
        let id = userInfo["id"] as! Int
        let type = userInfo["type"] as! String
        print("\(id) : \(type)")
        if type == "movie" {
            print("Going to Movie Detail from notification")
            routerPath?.navigate(to: .movieDetail(id: id))
        } else {
            print("Going to TV Series Detail from notification")
            routerPath?.navigate(to: .seriesDetail(id: id))
        }
        
    }
}

