//
//  SYAppDelegate+JPush.swift
//  SYNovelbb
//
//  Created by Mandora on 2020/10/19.
//  Copyright © 2020 Mandora. All rights reserved.
//

import Foundation
import AdSupport

extension SYAppDelegate: JPUSHRegisterDelegate {
    
    func setupJPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        var isProduction = true
        #if DEBUG
            isProduction = false
        #endif
        let entity = JPUSHRegisterEntity()
        entity.types = Int(UNAuthorizationOptions.alert.rawValue |
                            UNAuthorizationOptions.badge.rawValue |
                            UNAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: "fe3f6154cfd23346cd2e1570", channel: "app store", apsForProduction: isProduction)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
            JPUSHService.setBadge(0)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))  // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo;
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
            JPUSHService.setBadge(0)
            if userInfo["bid"] != nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "enterBookContentView"), object: self, userInfo: userInfo)
            }
          }
          completionHandler();  // 系统要求执行这个方法
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        if (notification != nil) && notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            // 从通知界面进入应用
        } else {
            // 从通知设置界面进入应用
        }
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        print("极光推送授权状态:%d",status)
        if status == .statusAuthorized {
            let jPushId = JPUSHService.registrationID()
            var idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            if idfa == "00000000-0000-0000-0000-000000000000" {
                idfa = String.uuid()
            }
            SYProvider.rx.request(.reportJPushInfo(phoneCode: idfa, jPushId: jPushId!))
                .qm_map(result: QMJPushModel.self)
                .subscribe { (response) in
                    if response.data != nil {
                        print("JPushId上传成功")
                    }
                } onError: { (error) in
                    print(error)
                }
                .disposed(by: disposeBag)
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: %@", error)
    }
    
}
