//
//  SignupViewController.swift
//  HowlTalk
//
//  Created by CHUNGEUNJI on 06/10/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignupViewController: UIViewController {

    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    var ref = Database.database().reference()
    var storage_ref = Storage.storage().reference()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (maker) in
            maker.right.top.left.equalTo(self.view)
            maker.height.equalTo(20)
        }
        color = remoteConfig["splash_background"].stringValue
        
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        statusBar.backgroundColor = UIColor(hex: color)
        emailTextField.backgroundColor = UIColor(hex: color)
        pwdTextField.backgroundColor = UIColor(hex: color)
        nameTextField.backgroundColor = UIColor(hex: color)
        
        signUpButton.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    @objc func signupEvent() {
        // Firebase Auth 과정을 따로 배워야한다...!
        Auth.auth().createUser(withEmail: emailTextField.text!, password: pwdTextField.text!) { (result, error) in
            
            if let result = result {
                let uid = result.user.uid
                print("uid : \(uid)")
                
                guard let image = self.imageview.image?.jpegData(compressionQuality: 0.75) else { return }
                
                self.storage_ref.child("users").child(uid).putData(image, metadata: nil, completion: { (data, error) in
                    let imageUrl = data.
                })
                self.ref.child("users").child(uid).setValue(["userName":self.nameTextField.text])
            }
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
        }
        
    }
    
    @objc func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SignupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func imagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageview.image = info[.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
}
