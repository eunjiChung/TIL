//
//  ViewController.swift
//  SimpleCalc3
//
//  Created by CHUNGEUNJI on 2018. 1. 18..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var leftInputField: UITextField!
    @IBOutlet weak var opInputField: UITextField!
    @IBOutlet weak var rightInputField: UITextField!
    
    @IBAction func presentCalc(_ sender: Any) {
        let leftNum = Int(leftInputField.text!)!
        let rightNum = Int(rightInputField.text!)!
        let op = opInputField.text!
        var result = 0
        
        switch op {
        case "+":
            result = leftNum + rightNum
        case "-":
            result = leftNum - rightNum
        case "*":
            result = leftNum * rightNum
        case "/":
            result = leftNum / rightNum
        default:
            alertCalc(title: "WARNING", msg: "NOT GOOD OPERATOR")
            return
        }
        
        alertCalc(title: "RESULT", msg: "\(leftNum) \(op) \(rightNum) = \(result)")
    }
    
    
    func alertCalc(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

