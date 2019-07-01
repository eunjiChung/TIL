//
//  FirstViewController.swift
//  DateCalc1
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder() // 포커스 집중
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputField.resignFirstResponder() // 포커스 해제
    }
    
}


extension FirstViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            guard let text = self.inputField.text, text.count > 0, let days = Int(text) else {
                self.resultLabel.text = ""
                return
            }
            
            // 1. Today
            let today = Date()
            // 2. 날짜 계산기 선언
            let cal = Calendar.current
            // 3. 계산할 날짜를 Component로 삽입하여 형식을 만들어준다
            var comp = DateComponents()
            comp.day = days
            
            if let resultDate = cal.date(byAdding: comp, to: today) {
                // 4. 날짜 형식 변환기
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                
                self.resultLabel.text = formatter.string(for: resultDate)
            }
        }
        
        return true
    }
}
























