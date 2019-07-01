//
//  ViewController.swift
//  ConnectionSample4
//
//  Created by CHUNGEUNJI on 2018. 1. 30..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func turnLabel(_ sender: Any) {
        textLabel.text = "Hello, Swift!!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

