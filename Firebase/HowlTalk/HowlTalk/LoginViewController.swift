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
    
    
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    var handle: AuthStateDidChangeListenerHandle?
    
    let auth = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 처음부터 로그아웃 시키는 버튼
        // try에 대해...다시 공부!!
        try! Auth.auth().signOut()
        
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
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 다음 화면으로 넘어가는 코드
        // handle 변수로 removeStateDidChangeListener까지 통제해줘야 다른 화면에서 User가 안불린다?
        handle = auth.addStateDidChangeListener { (auth, user) in
            if user != nil {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                self.present(view, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 얘를 해제시켜줘야 다른 화면에서 안불린다???
        auth.removeStateDidChangeListener(handle!)
    }
    
    @objc func presentSignup() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(view, animated: true, completion: nil)
    }
    
    @objc func loginEvent() {
        auth.signIn(withEmail: emailTextField.text!, password: pwdTextField.text!) { (result, error) in
            if error != nil {
                let alert = UIAlertController(title: "에러", message: error.debugDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
