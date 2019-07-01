//
//  ViewController.swift
//  SlackUI3
//
//  Created by CHUNGEUNJI on 2018. 4. 2..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SecondViewController {
            vc.urlString = (inputTextField.text ?? "") + ".slack.com"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            
            if let keyboardFrame = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = keyboardFrame.cgRectValue
                self.bottomConstraint.constant = frame.size.height + 10
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (noti) in
            self.bottomConstraint.constant = 20
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

}

extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var finalText = textField.text ?? ""
        
        if string.count == 0 {
            finalText = String(finalText[..<finalText.index(before: finalText.endIndex)])
        } else {
            finalText = (textField.text ?? "").appending(string)
        }
        
        
        UIView.animate(withDuration: 0.3) {
            let nsStr = NSString(string: finalText)
            let dict = [NSAttributedStringKey.font : self.inputTextField.font!]
            let width = nsStr.size(withAttributes: dict).width
            self.leadingConstraint.constant = width
            
            if finalText.count == 0 {
                self.placeholderLabel.text = "your-url.slack.com"
                self.nextButton.isEnabled = false
            } else {
                self.placeholderLabel.text = ".slack.com"
                self.nextButton.isEnabled = true
            }
        }
        
        return true
    }
}


























