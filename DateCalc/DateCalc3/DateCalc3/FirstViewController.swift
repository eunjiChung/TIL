//
//  FirstViewController.swift
//  DateCalc3
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
        inputField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputField.resignFirstResponder()
    }
}


extension FirstViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // [weak self] ???
        // 왜 다른 스레드로 동작?? -> 스레드를 없애면 text가 들어가지 않는 것처럼 보인다..왜?
        // 입력하면서 한편으로는 동시에 날짜를 계산하는 두 가지 일을 할때 스레드는 필요한 걸로....
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            guard let text = self.inputField.text, text.count > 0, let days = Int(text) else {
                self.resultLabel.text = ""
                return
            }
            
            let today = Date()
            let cal = Calendar.current
            var comp = DateComponents()
            comp.day = days
            
            if let resultDate = cal.date(byAdding: comp, to: today) {
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultLabel.text = formatter.string(for: resultDate)
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        return true
    }
}























