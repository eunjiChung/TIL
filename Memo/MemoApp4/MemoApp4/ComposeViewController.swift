//
//  ComposeViewController.swift
//  MemoApp4
//
//  Created by CHUNGEUNJI on 2018. 3. 22..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
import CoreData


// ViewController가 아니라 그냥 UIViewController의 context를 상속
extension UIViewController {
    // 1. context 선언
    var context : NSManagedObjectContext {
        // 2. AppDelegate 선언
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        // 3. AppDelegate의 Context == context 리턴
        return ad.persistentContainer.viewContext
    }
    
    func show(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}


class ComposeViewController: UIViewController {
    
    
    var memo : MemoEntity?
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var contentTextField: UITextView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = inputTextField.text, title.count > 0 else {
            show(message: "제목을 입력해주세요.")
            return
        }
        guard let content = contentTextField.text, content.count > 0 else {
            show(message: "내용을 입력해주세요.")
            return
        }
        
        if let editTarget = memo {
            editTarget.title = title
            editTarget.content = content
            editTarget.insertDate = Date()
        } else {
            if let newMemo = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context) as? MemoEntity {
                newMemo.title = title
                newMemo.content = content
                newMemo.insertDate = Date()
            }
        }
        
        
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch {
            show(message: error.localizedDescription)
        }
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let value = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = value.cgRectValue
                self?.bottomConstraint.constant = frame.height + 20
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                })
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.bottomConstraint.constant = 20
            
            UIView.animate(withDuration: 0.3, animations: {
                self?.view.layoutIfNeeded()
            })
        }
        
        
        if let editTarget = memo {
            title = "편집하기"
            inputTextField.text = editTarget.title
            contentTextField.text = editTarget.content
        } else {
            title = "새 메모"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if inputTextField.isFirstResponder {
            inputTextField.resignFirstResponder()
        }
        if contentTextField.isFirstResponder {
            contentTextField.resignFirstResponder()
        }
    }

}





















