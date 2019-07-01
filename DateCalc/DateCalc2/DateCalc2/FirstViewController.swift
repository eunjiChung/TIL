//
//  FirstViewController.swift
//  DateCalc2
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
        resultLabel.text = ""
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
        
        
        // asyncAfter???
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
                let form = DateFormatter()
                form.dateStyle = .long
                
                // 오...애니메이션 효과!!! >< 꺄
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultLabel.text = form.string(for: resultDate)
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        
        return true
    }
}






















