//
//  MainViewController.swift
//  HowlTalk
//
//  Created by CHUNGEUNJI on 14/10/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var array: [UserModel] = []
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(PeopleViewTableCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView!)
        
        tableView?.snp.makeConstraints { m in
            m.top.equalTo(view)
            m.bottom.left.right.equalTo(view)
        }
        
        // 데이터 가져오기?
        Database.database().reference().child("users").observe(.value) { (snapshot) in
            
            // 중복되는 데이터 제거?
            self.array.removeAll()
            
            let myUid = Auth.auth().currentUser?.uid
            
            for child in snapshot.children {
                let fchild = child as! DataSnapshot
                let userModel = UserModel()
                
                let value = fchild.value as! [String: String]
                
                userModel.userName = value["userName"]
                userModel.profileImageUrl = value["profileImageUrl"]
                userModel.uid = value["uid"]
                
                if userModel.uid == myUid {
                    continue
                }
                
                self.array.append(userModel)
            }
            
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PeopleViewTableCell
        
        let imageView = cell.peopleImageview
        
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(10)
            m.height.width.equalTo(50)
        }
        
        if let imageUrl = array[indexPath.row].profileImageUrl {
            URLSession.shared.dataTask(with: URL(string: imageUrl)!) { (data, response, error) in
                
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data!)
                    imageView.layer.cornerRadius = imageView.frame.size.width / 2
                    imageView.clipsToBounds = true
                }
            }.resume()
        }
        
         
        let label = cell.label!
        cell.addSubview(label)
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageView.snp.right).offset(20)
        }
        label.text = array[indexPath.row].userName
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        view?.destinationUid = self.array[indexPath.row].uid
        self.navigationController?.pushViewController(view!, animated: true)
    }
}

class PeopleViewTableCell: UITableViewCell {
    var peopleImageview = UIImageView()
    var label: UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(peopleImageview)
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
