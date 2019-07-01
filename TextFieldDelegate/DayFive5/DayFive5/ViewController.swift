//
//  ViewController.swift
//  DayFive5
//
//  Created by CHUNGEUNJI on 2018. 4. 2..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var listTableView: UITableView!
    
    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
    }
}


extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 0 else { return false }
        list.append(text)
        
        let ip = IndexPath(row: list.count - 1, section: 0)
        listTableView.insertRows(at: [ip], with: .automatic)
        
        textField.text = ""
        textField.becomeFirstResponder()
        
        return true
    }
}



extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let target = list[indexPath.row]
        cell.textLabel?.text = target
        
        return cell
    }
    
    
}
