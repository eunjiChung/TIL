//
//  ViewController.swift
//  UserNotiTest
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 11/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, Error) in
            print(didAllow)
        }
    }

    @IBAction func didTouchBtn(_ sender: Any) {
        // 메세지 작성 - UNMutableNotificationContent 클래스
        
        // 클래스니까 객체를 만들어준다!
        let content = UNMutableNotificationContent()
        content.title = "This is TITLE"
//        content.subtitle = "SubTitle"
        content.body = "This is Body"
        content.badge = 1
        
        // 이미지 보내고 싶을 경우!!!!!!
        // *****우선 이미지를 프로젝트 번들에 넣어줘야한다...
        // Asset 안됨!!!
        let imageName = "applelogo"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        // 이 다음에 알림 트리거 지정
        // 트리거 기준 : 특정 시간, 시간 간격, 위치 변경 기준
        // UNNotificationTrigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // 알림 요청
        // identifier : 여러 알림이 요청될 때 구분해주기 위한 것
        let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)

        // UNUserNotificationCenter에서 알림 예약
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

