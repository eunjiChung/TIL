//
//  ViewController.swift
//  dayFive
//
//  Created by CHUNGEUNJI on 2018. 1. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

// delegate : 이벤트 처리
// dataSource : 데이터를 전달

class ViewController: UIViewController {
    
    var list = [String]()
    
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputField.delegate = self  // 엔터 눌러서 추가하기
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// 이벤트 처리
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, text.count > 0 else {
            return true
        }
        
        list.append(text)
        
        // 1. talbeView 전체 갱신
//        tableView.reloadData()
        
        // 2. table 일부만 갱신 -> 전체 reload는 비효율적이라서
        // indexPath = row + section
        let ip = IndexPath(row: list.count - 1, section: 0) // list.count - 1 
        tableView.insertRows(at: [ip], with: .automatic)
        
        textField.text = ""
        textField.resignFirstResponder()
        
        return true
    }
}


// 얘를 위에 같이 쓸 수 있지만 그렇게 되면 코드가 복잡해지기 떄문에 extension을 써줌
// 얘도 delegate pattern을 따라감
// 데이터 전달
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 빈 값을 전달할때 최대한 빠르게 감지 가능
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
}























