//
//  ViewController.swift
//  SlackUI2
//
//  Created by CHUNGEUNJI on 2018. 4. 2..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func onNext(_ sender: Any) {
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SecondViewController {
            vc.urlString = inputTextField.text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            
            // 1. 키보드 높이 얻기
            if let frameValue = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                self.bottomConstraint.constant = keyboardFrame.size.height + 10
                
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
    // 텍스트 필드에 문자를 하나 입력/삭제할 때마다 호출
    // true 리턴 시 문자 반영, false 리턴 시 무시
    // 입력되는 중인 경우, string param으로 입력문자 전달
    // 삭제 시 빈 문자열 전달 -> 문자열 길이로 입력/삭제 판단
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var finalText = textField.text ?? ""
        
        // 1. finalText 만들기
        if string.count == 0 {
            // 실시간 문자열 삭제가 이루어지고 있는데, 삭제될 때마다 finalText 갱신
            finalText = String(finalText[..<finalText.index(before: finalText.endIndex)])
        } else {
            // 실시간 문자 입력 시
            // String이 구조체 -> 새로운 string을 더해준다
            // 이건 String 강의 부분 더 자세히 보기
            finalText = finalText.appending(string)
        }
        
        
        // 3. Leading Constraint 계산
        // 문자를 입력/삭제 할때마다 왼쪽 여백을 계산
        // NSString 클래스는 문자열 너비를 계산하는 메소드를 제공한다
        let nsStr = NSString(string: finalText)
        // 딕셔너리 = [문자열 관련 속성키 : 텍스트 필드에 설정된 폰트]
        let dict = [NSAttributedStringKey.font : inputTextField.font]
        let width = nsStr.size(withAttributes: dict).width
        leadingConstraint.constant = width
        
        
        // 2. Next버튼 토글 & placeholder 라벨 수정
        if finalText.count == 0 {
            print("count", (textField.text ?? "").count)
            
            nextButton.isEnabled = (textField.text ?? "").count - 1 > 0
            placeholderLabel.text = "your-url.slack.com"
        } else {
            nextButton.isEnabled = (textField.text ?? "").appending(string).count > 0
            placeholderLabel.text = ".slack.com"
        }
        
        
        
        return true
    }
}
































