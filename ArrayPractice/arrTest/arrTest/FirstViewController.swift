//
//  FirstViewController.swift
//  arrTest
//
//  Created by CHUNGEUNJI on 2018. 1. 15..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    var list = ["Apple", "Orange", "Banana"]
}



// <<<<도전과제>>>>>> table view 위에 text field 추가. 그리고 text field에 입력시 table view에 나오도록
// extension은 늘 class 밖에 와야함
extension FirstViewController: UITableViewDataSource {
    // 메소드 시그니처 외우기
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 section의 정확한 위치를 파악하고 싶으면 indexPath로. (????)
        
        
        // 이 경우에 한해서 강제추출 연산자 사용
        // delegate가 뭐지?
        // 이름들이 어느정도 document의 역할도 하는건가?
        
        // Data resource랑 연결 **** 많이 빠트림
        // dequeueReusableCell이 오버헤드를 막아줌
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // 오버헤드가 없도록 하기 위해 다시 cell을 재활용
        cell.textLabel?.text = list[indexPath.row] //"\(indexPath.row)"
        
        return cell
    }
    
    
}



























