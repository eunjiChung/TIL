//
//  TargetViewController.swift
//  SwitchTest
//
//  Created by CHUNGEUNJI on 11/07/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit

class TargetViewController: UIViewController {
    
    
    @IBOutlet weak var stateSwitch: UISwitch!
    let myUserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stateSwitch.isOn = myUserDefaults.bool(forKey: "switchState")
    }
    
    @IBAction func switchAction(_ sender: Any) {
        if stateSwitch.isOn {
            stateSwitch.setOn(false, animated: true)
        } else {
            stateSwitch.setOn(true, animated: true)
        }
        
        // 상태 셋팅
        // forKey는 스위치가 여러개인 경우를 대비한 식별자
        myUserDefaults.set(stateSwitch.isOn, forKey: "switchState")
    }
    

}
