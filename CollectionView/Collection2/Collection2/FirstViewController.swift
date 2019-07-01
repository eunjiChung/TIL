//
//  FirstViewController.swift
//  Collection2
//
//  Created by CHUNGEUNJI on 2018. 1. 21..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {
    
    var list = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // 이 부분이 어떤 작용인지 모르겠음
        let target = list[indexPath.row]
        cell.textLabel?.text = target
        
        return cell
    }
    

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func addTextButton(_ sender: Any) {
        guard let inputValue = inputTextField.text, inputValue.count > 0 else {
            return
        }
        
        list.append(inputValue)
        listTableView.reloadData()
        inputTextField.text = nil
        inputTextField.resignFirstResponder()
        print("appended")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

