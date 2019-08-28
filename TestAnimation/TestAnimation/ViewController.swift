//
//  ViewController.swift
//  TestAnimation
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 01/08/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var springLabel: UILabel!
    
    var labelPositionIsBottom = true
    var current: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        current = springLabel.center.y
        
        move()
    }

    func move() {
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.springLabel.center.y = self.current! + 10
        }, completion: nil)
    }

}

