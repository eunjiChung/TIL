//
//  ModalViewController.swift
//  ChangeVC5
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 01/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
