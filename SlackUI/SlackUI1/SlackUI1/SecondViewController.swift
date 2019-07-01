//
//  SecondViewController.swift
//  SlackUI1
//
//  Created by CHUNGEUNJI on 2018. 4. 2..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    // 전달받은 url
    var urlString: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBAction func moveToPrev(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabelBottomConstraint.constant = -20
        titleLabel.alpha = 0.0

        // Do any additional setup after loading the view.
        print(urlString)
    }

}


extension SecondViewController : UITextFieldDelegate {
    // 편집이 시작되기 직전에 호출
    // true리턴 시 편집 허용, false 리턴 시 편집 금지
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        }
        return true
    }
    
    // 편집이 종료되기 직전에 호출
    // true 리턴 시 편집 종료 허용, false 리턴 시 편집 종료 금지
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 2. Placeholder Update
        // 최종 문자열을 구성해야 한다 ????? -> string은 중간 문자열이기 때문에
        var finalText = textField.text ?? ""
        
        if string.count == 0 {
            // 삭제일 경우? ???
            finalText = String(finalText[..<finalText.index(before: finalText.endIndex)])
        } else {
            finalText = finalText.appending(string)
        }
        
        UIView.animate(withDuration: 0.3) {
            if finalText.count == 0 {
                self.placeholderLabel.alpha = 1.0
                self.titleLabelBottomConstraint.constant = -20
                self.titleLabel.alpha = 0.0
            } else {
                self.placeholderLabel.alpha = 0.0
                self.titleLabelBottomConstraint.constant = 20
                self.titleLabel.alpha = 1.0
            }
            
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}































