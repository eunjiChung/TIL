//
//  SecondViewController.swift
//  dayFour
//
//  Created by CHUNGEUNJI on 2018. 1. 17..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    // 클래스 생성 시점은 value 값이 없어서
    var value: String?
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    @IBAction func closeScene(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 대부분의 초기화는 여기서 작성
        valueLabel.text = value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
