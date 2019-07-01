//
//  ShowViewController.swift
//  ChangeVC3
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
