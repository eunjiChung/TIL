//
//  ViewController.swift
//  test2
//
//  Created by CHUNGEUNJI on 2018. 1. 10..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var leftInputField: UITextField!
    
    @IBOutlet weak var rightInputField: UITextField!
    
    
    
    
    func presentAlert(title: String, msg: String, okTitle: String = "확인"){
        // 아이폰에서 경고창을 띄우는 문법
        // 다음에 좀 더 간단하게 해봄
        // 함수 외우기
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle,
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        
        //        let cancelAction = UIAlertAction(title: "취소",
        //                                     style: .cancel,
        //                                     handler: nil)
        //        alert.addAction(cancelAction)
        
        present(alert, animated:  true, completion: nil)
    }
    
    @IBAction func showAlert(_ sender: Any) {
//        presentAlert(title: "경고", msg: "경고 메세지")
        
        // 느낌표는 다음에 설명해주심(Optional)
        let a = leftInputField.text!
        let b = rightInputField.text!
        
        let num1 = Int(a)!
        let num2 = Int(b)!
        
        // swift에서는 let을 쓰다가 오류가나면 var로 바꾼다 ㅎㅎㅎ
        let result = num1 + num2
//        let msg = String(result) >> 잘 안쓰는 문법
        // "\(result)" >> type converting이 가능한 문법 ***** 위의 줄이 더욱 간단해짐
        presentAlert(title: "결과", msg: "\(result)")
        
        // 도전과제!! 계산기 만들기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // 그냥 죽는 이유? 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

