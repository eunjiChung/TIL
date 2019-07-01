//
//  ViewController.swift
//  SlackUI1
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
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var inputField: UITextField!
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SecondViewController {
            dest.urlString = (inputField.text ?? "") + ".slack.com"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            // 키보드가 표시되기 직전에 호출
            
            // 키보드 높이 얻기
            if let frameValue = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                
                self.bottomConstraint.constant = keyboardFrame.size.height + 20
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded() // 레이아웃  업데이트 요청
                })
            }
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (noti) in
            self.bottomConstraint.constant = 20
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded() // 레이아웃  업데이트 요청
            })
        }
    }
}



extension ViewController : UITextFieldDelegate {
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
        
        // 3. placeholder 왼쪽 여백 업데이트
        // 구조체 형식의 String을 클래스 형식의 NSString으로 변환
        // 왜냐면 입력된 문자열 너비를 구하기 위해서 => NSString 클래스는 여기에 필요한 메소드 제공
        let nsStr = NSString(string: finalText)
        
        // 문자열 너비는 폰트를 기준으로 계산
        // 그래서 텍스트 필드에 설정되어 있는 폰트를 얻은 다음 크기 계산 메소드로 전달
        // 이 때는 딕셔너리 형태로 전달
        // NSAttributedStringKey에는 문자열과 관련된 속성을 구성할 때 사용할 키가 선언되어있다
        let dict = [NSAttributedStringKey.font : inputField.font!]
        let width = nsStr.size(withAttributes: dict).width
        leadingConstraint.constant = width
        
        if finalText.count == 0 {
            placeholderLabel.text = "your-url.slack.com"
        } else {
            placeholderLabel.text = ".slack.com"
        }
        
        // 1. Next버튼 활성화 토글 (????)
        if finalText.count == 0 {
            // 삭제일 경우
            // 여기서는 실제 삭제가 반영되지 않았기 때문에 길이에서 1을 빼 주어야 한다
            nextButton.isEnabled = (textField.text ?? "").count - 1 > 0
        } else {
            // 문자열이 반영되지 않은 상태이므로 세번째 파라미터를 가져와야 됨
            nextButton.isEnabled = (textField.text ?? "").appending(string).count > 0
        }
        
        return true
    }
}































