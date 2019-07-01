//
//  ViewController.swift
//  ChangeVC2
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(self.navigationController?.viewControllers)")
    }

    @IBAction func didTouchPresent(_ sender: Any) {
        let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController")
        modalVC?.modalTransitionStyle = .crossDissolve
        self.present(modalVC!, animated: true, completion: nil)
    }
    
    @IBAction func didTouchPush(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "PushViewController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    @IBAction func didTouchPushCode(_ sender: Any) {
        self.performSegue(withIdentifier: "showSegue", sender: self)
    }
}

