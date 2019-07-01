//
//  NaviViewController.swift
//  ChangeVC2
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class NaviViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\(self.navigationController?.viewControllers)")
    }
    
    @IBAction func didTouchPop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
