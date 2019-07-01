//
//  SecondViewController.swift
//  arrTest
//
//  Created by CHUNGEUNJI on 2018. 1. 15..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource {
    
    var dict = [String: Int]()
    var keys: [String]? // = dict.keys.sorted() >> 이건 오류남
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let list = keys {
//            return list.count
//        } else {
//            return 0
//        } >> 얘를 줄인게 바로 아래있는 코드 (리뷰하기)
        
        return keys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // 이거 수정해서 돌아가게 만드는게 도전과제
        // Dictionary가 실제로 Binding 되도록
        // Dictionary는 비어있지만, TextField로부터 받아오는걸로
        let targetKey = keys?[indexPath.row]
        let targetValue = dict[targetKey]
        cell.textLabel?.text = targetValue
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        keys = dict.keys.sorted() // 얘를 여기서 초기화한 이유는 무엇??
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

