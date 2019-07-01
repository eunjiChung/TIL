//
//  SecondViewController.swift
//  Collection2
//
//  Created by CHUNGEUNJI on 2018. 1. 21..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    
    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    var dict = [String: Int]()
    var keys: [String]?
    
    
    
    @IBAction func appendElement(_ sender: Any) {
        guard let keyStr = keyField.text, keyStr.count > 0 else {
            return
        }
        
        guard let valueStr = valueField.text, valueStr.count > 0,
            let num = Int(valueStr) else {
                return
        }
        
        
        dict[keyStr] = num
        keys = Array(dict.keys).sorted()
        
        listTableView.reloadData()
        keyField.text = nil
        valueField.text = nil
        
        
        // isFirstResponder ???
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


// 위에 상속하거나 extension으로 바깥에 선언하는거나 똑같??
extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys?.count ?? 0
        
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
















