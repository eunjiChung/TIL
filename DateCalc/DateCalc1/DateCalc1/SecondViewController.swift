//
//  SecondViewController.swift
//  DateCalc1
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

extension Date {
    func diffString(for date: Date) -> String? {
        let cal = Calendar.current
        let comp = cal.dateComponents([.day], from: self, to: date)
        
        if let day = comp.day {
            let fm = NumberFormatter()
            fm.numberStyle = .decimal
            return fm.string(for: day)
        }
        return nil
    }
}


class SecondViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        resultLabel.text = Date().diffString(for: selectedDate)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let picker = view.viewWithTag(100) as? UIDatePicker {
            let baseDate = Date(timeIntervalSinceNow: 3600 * 24 * 10)
            picker.date = baseDate
            
            resultLabel.text = Date().diffString(for: picker.date)
        }
    }

}





















