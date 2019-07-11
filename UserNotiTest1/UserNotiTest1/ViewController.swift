//
//  ViewController.swift
//  UserNotiTest1
//
//  Created by CHUNGEUNJI on 11/07/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (result, error) in
            print(result)
        }
    }


    @IBAction func didTouchButton(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "제목"
        content.body = "내용"
        content.badge = 1
        
        
        let imageName = "applelogo"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: ".png") else { return }
        
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

