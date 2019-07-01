//
//  SecondViewController.swift
//  SlackUI2
//
//  Created by CHUNGEUNJI on 2018. 4. 2..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var urlString : String?
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func onPrev(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 처음에는 타이틀을 숨긴다
        titleBottomConstraint.constant = -20
        titleLabel.alpha = 0.0
        
        print(urlString)
    }
}


extension SecondViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        }
        return true
    }
    
    // return 키 누를때 액션?
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
        
        UIView.animate(withDuration: 0.3) {
            if finalText.count == 0 {
                // 삭제하면 플레이스 홀더가 보이게
                self.placeholderLabel.alpha = 1.0
                self.titleBottomConstraint.constant = -20
                self.titleLabel.alpha = 0.0
            } else {
                // 문자열이 있으면 플레이스 홀더가 안보이게
                self.placeholderLabel.alpha = 0.0
                self.titleBottomConstraint.constant = 10
                self.titleLabel.alpha = 1.0
            }
            
            self.view.layoutIfNeeded()
        }
        
        return true
    }
}


































