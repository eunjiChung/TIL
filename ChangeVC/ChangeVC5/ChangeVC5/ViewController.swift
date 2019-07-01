//
//  ViewController.swift
//  ChangeVC5
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 01/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTouchShow(_ sender: Any) {
        let showVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowViewController")
        self.show(showVC!, sender: self)
    }
    
    @IBAction func didTouchModal(_ sender: Any) {
        let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController")
        modalVC?.modalTransitionStyle = .crossDissolve
        self.present(modalVC!, animated: true, completion: nil)
    }
    
    @IBAction func didTouchShowCode(_ sender: Any) {
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let destVC = segue.destination as! ShowCodeViewController
            destVC.str = "SHOW!!!!"
        }
    }
    
}

