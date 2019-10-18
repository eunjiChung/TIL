//
//  ChatRoomsViewController.swift
//  HowlTalk
//
//  Created by eunji on 18/10/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var uid: String!
    var chatrooms = [ChatModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.uid = Auth.auth().currentUser?.uid
        self.getChatroomsList()
    }
    
    func getChatroomsList() {
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/" + uid).queryEqual(toValue: true).observeSingleEvent(of: .value) { (dataSnapShot) in
            
            for item in dataSnapShot.children.allObjects as! [DataSnapshot] {
                if let chatroomdic = item.value as? [String: AnyObject] {
                    let chatModel = ChatModel(JSON: chatroomdic)
                    self.chatrooms.append(chatModel!)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath)
        return cell
    }
}
