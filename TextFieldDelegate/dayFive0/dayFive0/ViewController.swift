//
//  ViewController.swift
//  dayFive0
//
//  Created by CHUNGEUNJI on 2018. 1. 24..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var list = [String]()
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        inputField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// 얘는 뭐지? 왜 DataSource에서 안해주고 여기로 보냈지?
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 0 else {
            return true     // 왜 트루인가,,,
        }
        
        list.append(text)
        tableView.reloadData()
//        let ip = IndexPath(row: list.count, section: 0)
//        tableView.insertRows(at: [ip], with: .automatic)
        
        textField.text = ""
        textField.resignFirstResponder()
        
        return true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
}
