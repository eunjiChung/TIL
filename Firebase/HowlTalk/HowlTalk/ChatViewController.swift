//
//  ChatViewController.swift
//  HowlTalk
//
//  Created by eunji on 15/10/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextield: UITextField!
    
    var uid: String?
    var chatRoomUid: String?
    var destinationUid: String?
    
    var comments: [ChatModel.Comment] = []
    var userModel: UserModel?
    
    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = Auth.auth().currentUser?.uid // 내 uid 받아온 거
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        self.tabBarController?.tabBar.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            
            if self.comments.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item: self.comments.count - 1, section: 0), at: .bottom, animated: true)
            }
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.bottomConstraint.constant = 20
        self.view.layoutIfNeeded()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func createRoom() {
        let createRoomInfo: Dictionary<String, Any> = [
            "users" : [
                uid! : true,
                destinationUid! : true
            ]
        ]
        
        if let chatRoomUID = chatRoomUid {
            let value: Dictionary<String, Any> = [
                "uid" : uid!,
                "message" : chatTextield.text!,
                "timestamp" : ServerValue.timestamp()
            ]
            
            ref.child("chatrooms").child(chatRoomUID).child("comments").childByAutoId().setValue(value) { (error, reference) in
                self.chatTextield.text = ""
            }
        } else {
            self.sendButton.isEnabled = false
            // 방 생성 코드
            ref.child("chatrooms").childByAutoId().setValue(createRoomInfo) { (error, ref) in
                if error == nil {
                    self.checkChatRoom()
                }
            }
        }
        
    }
    
    // 중복 채팅방 방지
    func checkChatRoom() {
        ref.child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                
                if let chatRoomdic = item.value as? [String: AnyObject] {
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    
                    if chatModel?.users[self.destinationUid!] == true {
                        self.chatRoomUid = item.key
                        self.sendButton.isEnabled = true
                        self.getDestinationInfo()
                    }
                }
            }
        }
    }
    
    func getDestinationInfo() {
        // 방 정보를 받아와서 key에 따라 메세지 리스트를 가져온다 (채팅방 DB)
        ref.child("users").child(self.destinationUid!).observeSingleEvent(of: .value) { dataSnapShot in
            self.userModel = UserModel()
            
            let value = dataSnapShot.value as! [String: String]
            
            self.userModel?.userName = value["userName"]
            self.userModel?.profileImageUrl = value["profileImageUrl"]
            self.userModel?.uid = value["uid"]
            
            self.getMessageList()
        }
    }
    
    func getMessageList() {
        ref.child("chatrooms").child(self.chatRoomUid!).child("comments").observe(.value) { (dataSnapShot) in
            self.comments.removeAll()
            
            for item in dataSnapShot.children.allObjects as! [ DataSnapshot] {
                let comment = ChatModel.Comment(JSON: item.value as! [String: AnyObject])
                self.comments.append(comment!)
            }
            
            self.tableView.reloadData()
            
            if self.comments.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item: self.comments.count - 1, section: 0), at: .bottom, animated: true)
            }
            
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.comments[indexPath.row].uid == uid {
            let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            view.myLabelMessage.text = self.comments[indexPath.row].message
            view.myLabelMessage.numberOfLines = 0
            
            if let time = self.comments[indexPath.row].timeStamp {
                view.labelTimeStamp.text = time.toDayTime
            }
            
            return view
        } else {
            let view = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            view.labelName.text = userModel?.userName
            view.labelMessage.text = self.comments[indexPath.row].message
            view.labelMessage.numberOfLines = 0
            let url = URL(string: self.userModel!.profileImageUrl!)
            let task = URLSession.shared.dataTask(with: url!) { (data, reponse, error) in
                DispatchQueue.main.async {
                    view.imageViewProfile.image = UIImage(data: data!)
                    view.imageViewProfile.layer.cornerRadius = view.imageViewProfile.frame.width/2
                    view.imageViewProfile.clipsToBounds = true
                }
            }
            
            task.resume()
            
            if let time = self.comments[indexPath.row].timeStamp {
                view.labelTimeStamp.text = time.toDayTime
            }
            
            return view
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension Int {
    
    var toDayTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
    }
}

class MyMessageCell: UITableViewCell {
    @IBOutlet weak var myLabelMessage: UILabel!
    @IBOutlet weak var labelTimeStamp: UILabel!
    
    
}

class DestinationMessageCell: UITableViewCell {
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var labelTimeStamp: UILabel!
}
