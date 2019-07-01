//
//  ResultViewController.swift
//  CalcModal2
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    
    var msg: String?
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultLabel.text = msg
    }

}
