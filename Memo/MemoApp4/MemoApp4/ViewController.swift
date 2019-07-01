//
//  ViewController.swift
//  MemoApp4
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var list = [MemoEntity]()
    
    lazy var df : DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMemo()
    }
    
    func fetchMemo() {
        list.removeAll()
        
        let request = NSFetchRequest<MemoEntity>(entityName: "Memo")
        let sortByDate = NSSortDescriptor(key: "insertDate", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortByDate, sortByTitle]
        
        do {
            let list = try context.fetch(request)
            self.list = list
            listTableView.reloadData()
        } catch {
            show(message: error.localizedDescription)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("detailSegue"):
            if let vc = segue.destination as? DetailViewController, let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
                vc.memo = list[indexPath.row]
            }
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
        cell.titleLabel.text = target.title
        
        if let content = target.content, content.count > 200 {
            let to = content.index(content.startIndex, offsetBy: 200)
            cell.contentLabel.text = "\(content[..<to])..."
        } else {
            cell.contentLabel.text = target.content
        }
        
        cell.dateLabel.text = df.string(for: target.insertDate)
        
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
            context.delete(target)
            
            do {
                try context.save()
                list.remove(at: indexPath.row)
                listTableView.deleteRows(at: [indexPath], with: .right)
            } catch {
                show(message: error.localizedDescription)
            }
        default:
            break
        }
    }
}


