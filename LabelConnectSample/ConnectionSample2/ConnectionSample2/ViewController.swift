//
//  ViewController.swift
//  ConnectionSample2
//
//  Created by CHUNGEUNJI on 2018. 1. 25..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func resultButton(_ sender: Any) {
        resultLabel.text = "Hello, Swift!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

