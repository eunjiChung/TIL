//
//  DetailViewController.swift
//  MemoApp3
//
//  Created by CHUNGEUNJI on 2018. 3. 23..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    
    var memo : MemoEntity?
    
    @IBOutlet weak var contentLabel: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = memo?.title
        contentLabel.text = memo?.content
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        dateLabel.text = df.string(for: memo?.insertDate)
    }

    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            self.deleteMemo()
        }
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteMemo() {
        
        if let target = memo {
            context.delete(target)
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                show(message: error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func sendEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            
            if let subject = memo?.title {
                composer.setSubject(subject)
            }
            
            if let body = memo?.content {
                composer.setMessageBody(body, isHTML: false)
            }
            
            present(composer, animated: true, completion: nil)
        } else {
            show(message: "메일을 보낼 수 없습니다.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("editSegue"):
            if let navi = segue.destination as? UINavigationController, let vc = navi.topViewController as? ComposeViewController {
                vc.memo = memo
            }
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
}



extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            show(message: "메일을 성공적으로 보냈습니다.")
        default:
            break
        }
        
        // ???
        controller.dismiss(animated: true, completion: nil)
    }
}
















