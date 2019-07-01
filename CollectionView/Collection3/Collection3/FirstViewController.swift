//
//  FirstViewController.swift
//  Collection3
//
//  Created by CHUNGEUNJI on 2018. 1. 21..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var keyField: UITextField!
    
    @IBOutlet weak var valueField: UITextField!
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    var dict = [String: Int]()
    var keys: [String]?
    
    
    @IBAction func addElement(_ sender: Any) {
        guard let keyStr = keyField.text, keyStr.count > 0 else {
            return
        }
        
        guard let valueStr = valueField.text, valueStr.count > 0, let num = Int(valueStr) else {
            return
        }
        
        dict[keyStr] = num
        keys = Array(dict.keys).sorted()
        
        listTableView.reloadData()
        keyField.text = nil
        valueField.text = nil
        
        if keyField.isFirstResponder {
            keyField.resignFirstResponder()
        }
        if valueField.isFirstResponder {
            valueField.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}





extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys?.count ?? 0    //type casting
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if let targetKey = keys?[indexPath.row], let targetValue = dict[targetKey] {
            cell.textLabel?.text = "\(targetKey)"
            cell.detailTextLabel?.text = "\(targetValue)"
        }
        
        return cell
    }
}


















