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
        // 사용자를 만들고 등록하는 과정
        Auth.auth().createUser(withEmail: emailTextField.text!, password: pwdTextField.text!) { (result, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }

            // 사용자의 uid를 가져옴
            if let result = result {
                let uid = result.user.uid
                
                // 이미지 뷰의 이미지를 data로 만듦
                guard let image = self.imageview.image else { return }
                guard let data = image.jpegData(compressionQuality: 0.75) else { return }
                
                // storage의 어느 위치(?)에 넣어줄지 정함
                let storageRef = self.storage_ref.child("users").child(uid)
                // 해당 위치에 생성한 data를 넣어줌 (metaData는 무엇...?)
                storageRef.putData(data, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print("This is Error \(error.debugDescription)")
                        return
                    }
                    
                    // 해당 위치의 이미지 url을 다운로드한다
                    storageRef.downloadURL(completion: { (url, storageError) in
                        if let storageError = storageError {
                            print("Error: \(storageError.localizedDescription)")
                            return
                        }
                        
                        guard let downloadURL = url else {
                            return
                        }
                        
                        let values = ["userName": self.nameTextField.text!,
                                      "profileImageUrl": downloadURL.absoluteString,
                                      "uid" : uid]
                        
                        // 이 정보를 users의 DB에 넣어줌
                        self.ref.child("users").child(uid).setValue(values) { (error, reference) in
                            self.cancelEvent()
                        }
                    })
                })
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
