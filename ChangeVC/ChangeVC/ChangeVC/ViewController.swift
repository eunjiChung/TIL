//
//  ViewController.swift
//  ChangeVC
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 18/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    // 1. Modal로 나타나도록 코드로 제어 (present <-> dismiss)
    @IBAction func didTouchPresentVC(_ sender: Any) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NewViewController")
        newVC?.modalTransitionStyle = .coverVertical
        self.present(newVC!, animated: true, completion: nil)
    }
    
    // 2. 네비게이션 컨트롤러를 사용하여 화면 전환 (push <-> pop)
    @IBAction func didTouchPushVC(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "PushViewController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    // 3. Segue로 ViewController 전환
    @IBAction func didTouchPushByCode(_ sender: Any) {
        self.performSegue(withIdentifier: "showSegue", sender: self)
    }
    
}

