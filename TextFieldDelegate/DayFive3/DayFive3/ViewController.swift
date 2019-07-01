//
//  ViewController.swift
//  DayFive3
//
//  Created by CHUNGEUNJI on 2018. 3. 29..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var list = [String]()
    
    @IBOutlet weak var textInputField: UITextField!
    
    @IBOutlet weak var listTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textInputField.delegate = self
    }

}


extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textInputField.text, text.count > 0 else { return false }
        list.append(text)
        print(list)
        
        // section과 row의 차이?
        let ip = IndexPath(row: list.count - 1 , section: 0)
        listTableView.insertRows(at: [ip], with: .automatic)
        textInputField.text = ""
        textInputField.becomeFirstResponder() //???
        return true
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummy")!
        
        let target = list[indexPath.row]
        cell.textLabel?.text = target
        return cell
    }
    
    
}

























