//
//  ViewController.swift
//  TableViewBasic1
//
//  Created by CHUNGEUNJI on 2018. 1. 18..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    // shift + cmd + A -> Add all missing...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100  // 행의 갯수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

