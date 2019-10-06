//
//  LoginViewController.swift
//  HowlTalk
//
//  Created by CHUNGEUNJI on 06/10/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (maker) in
            maker.right.top.left.equalTo(self.view)
            maker.height.equalTo(20)
        }
        
        color = remoteConfig["splash_background"].stringValue
        
        statusBar.backgroundColor = UIColor(hex: color)
        loginButton.backgroundColor = UIColor(hex: color)
        signinButton.backgroundColor = UIColor(hex: color)

        signinButton.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func presentSignup() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(view, animated: true, completion: nil)
    }

}
