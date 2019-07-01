//
//  AppDelegate.swift
//  Alarm
//
//  Created by CHUNGEUNJI on 2018. 2. 7..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

let NewNotificationDidReceiveNotification = Notification.Name(rawValue: "aaa")


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 사용자에게 요청하는 코드 넣는 곳
        
        
        // UserNotification : 로컬과 리모트 notification이 합쳐진 것
        // 사용자에게 허가를 얻은 types -> 새로운 방법이 있지만 이 패턴부터 이해해야함
        let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        // 사용자에게 팝업이 표시되는 것
        application.registerUserNotificationSettings(setting)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // 얘는 언제 호출되서 쓰이는거야...
    // ViewController에 데이터를 전달하기 위해 그냥 notification을 쓴다 -> 왜냐면 얘랑 viewController 둘이 연결이 안되어 있기 때문
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        NotificationCenter.default.post(name: NewNotificationDidReceiveNotification, object: notification)
        
    }
}
























