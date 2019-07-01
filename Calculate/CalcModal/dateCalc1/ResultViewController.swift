//
//  ResultViewController.swift
//  dateCalc1
//
//  Created by CHUNGEUNJI on 2018. 1. 24..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func dismissScene(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var msg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultLabel.text = msg
    }


}
