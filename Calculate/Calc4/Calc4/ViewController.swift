//
//  ViewController.swift
//  Calc4
//
//  Created by CHUNGEUNJI on 2018. 1. 25..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftInputField: UITextField!
    
    @IBOutlet weak var opInputField: UITextField!
    
    @IBOutlet weak var rightInputField: UITextField!
    
    @IBAction func calcResult(_ sender: Any) {
        guard let leftInput = leftInputField.text, leftInput.count > 0, let leftNum = Int(leftInput) else {
            return
        }
        guard let rightInput = rightInputField.text, rightInput.count > 0, let rightNum = Int(rightInput) else {
            return
        }
        guard let op = opInputField.text, op.count > 0 else {
            return
        }
        
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
            displayAlert(title: "WARNING!!!!", msg: "부적절한 연산자")
            return
        }
        
        displayAlert(title: "결과", msg: "\(leftNum) \(op) \(rightNum) = \(result)")
        
        leftInputField.text = ""
        rightInputField.text = ""
        opInputField.text = ""
    }
    
    func displayAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

