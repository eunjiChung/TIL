//
//  FirstViewController.swift
//  DateCalc0
//
//  Created by CHUNGEUNJI on 2018. 1. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

// 이 친구를 delegate로 만들어줌
class FirstViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    // 화면 초기화 코드는 대부분 여기에 넣어줌
    // 얘는 Scene이 생성된 이후 한번만 호출됨
    override func viewDidLoad() {
        super.viewDidLoad()

        resultLabel.text = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 콜백 메소드라서 상위구현을 반드시 호출해줘야됨
        super.viewWillAppear(animated)
        
        // 첫번째로 포커스 가는 애 지정 -> 키패드 나타남
        inputField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 포커스를 해제해서 키패드를 없애줌
        inputField.resignFirstResponder()
    }


    // textField를 delegate로 만들어줌 -> tableView도 마찬가지였음 (????)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // execute에서 그냥 엔터
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // 후에 실행되는 코드. text가져옴
            guard let text = self.inputField.text, text.count > 0, let days = Int(text) else{
                self.resultLabel.text = ""
                return
            }
            
            // Date() : Swift에서 날짜를 처리하는 구조체
            let today = Date()
            
            let cal = Calendar.current
            var comp = DateComponents()
            comp.day = days
            
            // 원래 Optional Date형이라서 Optional Binding
            if let resultDate = cal.date(byAdding: comp, to: today) {
                // 날짜형을 문자열로 변환해줘야됨
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                
                // from말고 for
                self.resultLabel.text = formatter.string(for: resultDate)
            }
        }

        return true
    }
}



















