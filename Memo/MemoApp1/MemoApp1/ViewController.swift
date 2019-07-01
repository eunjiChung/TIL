//
//  ViewController.swift
//  MemoApp1
//
//  Created by CHUNGEUNJI on 2018. 3. 13..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    // MemoEntity 속성의 배열
    // Data Entity가 Class도 되는것?
    var list = [MemoEntity]()
    
    
    // closure 형식...
    lazy var df: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ??????
        listTableView.estimatedRowHeight = 100
        listTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // 메모를 CoreData에서 불러오는 기능
    func fetchMemo() {
        list.removeAll() //?????
        
        // 검색요청을 저장소에 날릴 애
        let request = NSFetchRequest<MemoEntity>(entityName: "Memo")
        // ascending?
        let sortByDate = NSSortDescriptor(key: "insertDate", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortByDate, sortByTitle]
        
        do {
            // request를 날리고 패치해옴
            let list = try context.fetch(request)
            self.list = list // 새로 패치해온 리스트를 원래 리스트에 갖다붙임
            listTableView.reloadData()
        } catch {
            show(message: error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemo()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("detailSegue"):
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    
}



extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as! MemoTableViewCell
        
        let target = list[indexPath.row]
        cell.memoTitleLabel.text = target.title
        
        if let content = target.content, content.count > 200 {
            // content 내부, 앞의 param부터 뒤에 제시된 범위까지 거리 리턴
            let to = content.index(content.startIndex, offsetBy: 200)
            // content[..<to] : to보다 작은 범위의 content 내용만 표기
            cell.memoContentLabel.text = "\(content[..<to])..."
        } else {
            cell.memoContentLabel.text = target.content
        }
        
        cell.memoDateLabel.text = df.string(for: target.insertDate)
        
        return cell
    }
    
    
}



extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let target = list[indexPath.row]
            context.delete(target) // 삭제를 두번?
            
            do {
                try context.save()
                
                list.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                show(message: error.localizedDescription)
            }
        default:
            break
        }
    }
}


































