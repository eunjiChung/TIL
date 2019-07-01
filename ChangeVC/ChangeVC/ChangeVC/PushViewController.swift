//
//  PushViewController.swift
//  ChangeVC
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 18/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTouchBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
