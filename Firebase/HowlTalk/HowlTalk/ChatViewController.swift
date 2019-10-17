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
                "message" : chatTextield.text!
            ]
            
            ref.child("chatrooms").child(chatRoomUID).child("comments").childByAutoId().setValue(value)
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
            return view
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


class MyMessageCell: UITableViewCell {
    @IBOutlet weak var myLabelMessage: UILabel!
    
    
}

class DestinationMessageCell: UITableViewCell {
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
}
