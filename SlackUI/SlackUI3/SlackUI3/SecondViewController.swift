//
//  SecondViewController.swift
//  SlackUI3
//
//  Created by CHUNGEUNJI on 2018. 4. 2..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var urlString : String?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    
    @IBAction func onPrev(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleBottomConstraint.constant = -20
        titleLabel.alpha = 0.0
        
        print(urlString)
    }

}



extension SecondViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var finalText = textField.text ?? ""
        
        if string.count == 0 {
            finalText = String(finalText[..<finalText.index(before: finalText.endIndex)])
        } else {
            finalText = (textField.text ?? "").appending(string)
        }
        
        let nsStr = NSString(string: finalText)
        let dict = [NSAttributedStringKey.font : self.inputTextField.font!]
        let height = nsStr.size(withAttributes: dict).height
        
        UIView.animate(withDuration: 0.3) {
            if finalText.count == 0 {
                self.titleBottomConstraint.constant = -10 - height
                self.titleLabel.alpha = 0.0
                self.placeholderLabel.alpha = 1.0
            } else {
                self.titleBottomConstraint.constant = 10
                self.titleLabel.alpha = 1.0
                self.placeholderLabel.alpha = 0.0
            }
            
            self.view.layoutIfNeeded()
        }
        
        return true
    }
}





























