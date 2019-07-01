//
//  SecondViewController.swift
//  DateCalc0
//
//  Created by CHUNGEUNJI on 2018. 1. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

// 얘는 뭘 위한 확장,,,,?
// 얘를 잘 만들면 코드길이가 줄어듦
extension Date {
    // 실패할 수도 있으니 Optional을 리턴
    func diffString(for date: Date) -> String? {
        let calendar = Calendar.current
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
    
    // DatePicker는 Action으로 연결해준다
    // sender는 date를 보내주는 class
    @IBAction func dateChanged(_ sender: UIDatePicker) {
//        print(sender.date)
        let selectedDate = sender.date
        resultLabel.text = Date().diffString(for: selectedDate)
    }
    
    
    // 초기화하는 곳
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View의 tag를 통해 접근 : ViewTagging
        // Type Conversion 복습하기
        if let picker = view.viewWithTag(100) as? UIDatePicker{
            
            // 10일 뒤의 시간 지정
            let baseDate = Date(timeIntervalSinceNow: 3600 * 24 * 10)
            picker.date = baseDate
            
            // extension으로 차이가 나는 날짜를 만들어서 전달
//            let today = Date()
//            picker.minimumDate = today.date(after: -7)
//            picker.maximumDate = today.date(after: 365)
            
            resultLabel.text = Date().diffString(for: picker.date)
        }
    }
}


















