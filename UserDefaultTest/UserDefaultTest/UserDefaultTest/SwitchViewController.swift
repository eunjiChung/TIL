//
//  SwitchViewController.swift
//  UserDefaultTest
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 31/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {

    
    @IBOutlet weak var TestSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TestSwitch.isOn = myUserDefaults.bool(forKey: "switchState")
    }
    
    @IBAction func switchAction(_ sender: Any) {
        myUserDefaults.set(TestSwitch.isOn, forKey: "switchState")
    }
    
    
}
