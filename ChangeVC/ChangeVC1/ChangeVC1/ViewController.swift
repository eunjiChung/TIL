//
//  ViewController.swift
//  ChangeVC1
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 18/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\(self.navigationController?.viewControllers)")
    }
    
    @IBAction func didTouchPresentBtn(_ sender: Any) {
        let presentVC = self.storyboard?.instantiateViewController(withIdentifier: "PresentViewController")
        presentVC?.modalTransitionStyle = .flipHorizontal
        self.present(presentVC!, animated: true, completion: nil)
    }
    
    @IBAction func didTouchPushBtn(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "PushViewController")
        self.navigationController?.show(pushVC!, sender: self)
    }
    
    @IBAction func didTouchPushCodeBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "showNext", sender: self)
    }
    
}

