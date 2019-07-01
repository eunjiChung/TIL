//
//  SegueViewController.swift
//  ChangeVC3
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/06/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class SegueViewController: UIViewController {

    @IBOutlet weak var segueLabel: UILabel!
    var str : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segueLabel.text = str
    }
    
    @IBAction func didTouchBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
