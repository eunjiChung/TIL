//
//  NewViewController.swift
//  ChangeVC
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 18/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchExit(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil) ???? 위와 차이는?
    }
    
}
