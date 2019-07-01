//
//  SecondViewController.swift
//  DateCalc3
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit


extension Date {
    func diffString(for date: Date) -> String? {
        // 1. calendar 관리 선언
        let calendar = Calendar.current
        // 2. DateComponent 선언 -> 두 날짜 사이의 차를 반환
        // (첫번째 변수는 어느 comp를 비교할 것인지, start, end)
        let comp = calendar.dateComponents([.day], from: self, to: date)
        
        if let days = comp.day {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            return formatter.string(for: days)
        }
        
        return nil
    }
}




class SecondViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    // sender로 Date를 받는다
    // 주의할 점은 타입을 UIDatePicker로 설정해야된다는 것!! >> 어느때???
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        print(sender.date)
        let selectedDate = sender.date
        resultLabel.text = Date().diffString(for: selectedDate)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // base 날짜 나타내기
        if let picker = view.viewWithTag(100) as? UIDatePicker {
            
            // 10일 뒤가 base
            let baseDate = Date(timeIntervalSinceNow: 3600 * 24 * 10)
            picker.date = baseDate
            
            resultLabel.text = Date().diffString(for: picker.date)
        }
        
    }

}



















