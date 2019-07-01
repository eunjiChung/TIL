//
//  ViewController.swift
//  ChangeVC3
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTouchModalBtn(_ sender: Any) {
        let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController")
        modalVC?.modalTransitionStyle = .partialCurl
        self.present(modalVC!, animated: true, completion: nil)
    }
    
    @IBAction func didTouchShowBtn(_ sender: Any) {
        let showVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowViewController")
        self.navigationController?.show(showVC!, sender: self)
    }
    
    @IBAction func didTouchSegueBtn(_ sender: Any) {
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let destVC = segue.destination as! SegueViewController
            destVC.str = "This is passing message"
        }
    }
}

