//
//  ViewController.swift
//  CalcModal2
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftInputField: UITextField!
    
    @IBOutlet weak var opField: UITextField!
    
    @IBOutlet weak var rightInputField: UITextField!
    
    
    func processResult() -> String? {
        guard let leftText = leftInputField.text, leftText.count > 0, let leftNum = Int(leftText) else {
            //            displayAlert()
            return nil
        }
        guard let rightText = rightInputField.text, rightText.count > 0, let rightNum = Int(rightText) else {
            return nil
        }
        guard let op = opField.text, op.count > 0 else {
            return nil
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
            return nil
        }
        
        return "\(leftNum) \(op) \(rightNum) = \(result)"
        
    }
    
    
    
    @IBAction func calcAction(_ sender: Any) {
        guard let msg = processResult() else {
            return
        }
        
        displayAlert(title: "RESULT", msg: msg)
    }
    
    func displayAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultViewController {
            vc.msg = processResult()
        }
    }


}

