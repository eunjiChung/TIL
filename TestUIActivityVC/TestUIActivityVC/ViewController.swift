//
//  ViewController.swift
//  TestUIActivityVC
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 11/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTouchShareTextMsgButton(_ sender: Any) {
        let text = "This is some text that I want to share"
        let text2 = "WOW!!!!!!!!!"
        let textToShare = [text, text2]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
//        activityVC.excludedActivityTypes = [.airDrop, .postToFacebook]
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func didTouchShareImageBtn(_ sender: Any) {
        
    }
}

