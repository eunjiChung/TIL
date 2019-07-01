//
//  FirstViewController.swift
//  Collection1
//
//  Created by CHUNGEUNJI on 2018. 1. 18..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {
    
    var list = [String]() // 그냥 String array 표현 방식의 하나?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // list에 아무것도 없는데...?
        let target = list[indexPath.row]
        cell.textLabel?.text = target
        
        return cell
    }
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func addElement(_ sender: Any) {
        guard let inputValue = inputField.text, inputValue.count > 0 else {
            return
        }
        
        list.append(inputValue)
        listTableView.reloadData()
        inputField.text = nil
        // dismiss keyboard
        inputField.resignFirstResponder()
        print("appended")
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // list에 값 추가는 왜 여기서..?
//        list.append("First")
//        list.append("Second")
//        list.insert("Third", at: 0)
    }
}

