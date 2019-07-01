//
//  ViewController.swift
//  SimpleCalc2
//
//  Created by CHUNGEUNJI on 2018. 1. 18..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftInputText: UITextField!
    @IBOutlet weak var rightInputText: UITextField!
    @IBOutlet weak var opInputText: UITextField!
    
    @IBAction func performResult(_ sender: Any) {
        let leftNum = Int(leftInputText.text!)!
        let rightNum = Int(rightInputText.text!)!
        let op = opInputText.text!
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
            alertAction(title: "WARNING!!!!", msg: "지원하지 않는 연산자~")
            return
        }
        
        alertAction(title: "결과", msg: "\(leftNum) \(op) \(rightNum) = \(result)")
    }
    
    func alertAction(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

