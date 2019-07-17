//
//  ViewController.swift
//  SwitchTest
//
//  Created by CHUNGEUNJI on 11/07/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func moveNextVC(_ sender: Any) {
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBAction func didTouchButton(_ sender: Any) {
        
    }
    
}

