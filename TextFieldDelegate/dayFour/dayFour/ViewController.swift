//
//  ViewController.swift
//  dayFour
//
//  Created by CHUNGEUNJI on 2018. 1. 17..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var inputField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 얘는 우리가 호출하는게 아니라 segue가 알아서 호출
        // 만들어주기만 하면 됨
        let source = segue.source // 출발지
        let dest = segue.destination // 목적지
        
        guard let text = inputField.text, text.count > 0 else {
            fatalError("텍스트입력 오류")  // 공부할땐 이렇게 쓰기
            // return
        }
        
        // 목적지 Controller로 Type Casting 해서 전달 (*****)
        // 가장 기초적임. 앞으로 우리가 늘 쓸 것이기 때문에 외우면 됨.
        guard let destVC = dest as? SecondViewController else {
            fatalError("타입캐스팅 오류")
            // return
        }
        
        destVC.value = text
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

