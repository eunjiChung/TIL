//
//  FirstViewController.swift
//  arrPractice
//
//  Created by CHUNGEUNJI on 2018. 1. 17..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {
    
    var list = [String]() //?????
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        type(of: cell)
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
        
        // reload table
        listTableView.reloadData()
        
        // reset textField
        inputField.text = nil
        
        // dismiss keyboard
        
        
        print("appended")  // ????
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        list.append("First")
//        list.append("Second")
//        list.insert("Zero", at: 0)
    }

    
}

