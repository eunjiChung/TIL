
import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification이 저장되어있는 배열
        // 얘를 TableView랑 바인딩할 거임
//        UIApplication.shared.scheduledLocalNotifications
        NotificationCenter.default.addObserver(forName: NewNotificationDidReceiveNotification, object: nil, queue: OperationQueue.main) { (noti) in
            if let localNoti = noti.object as? UILocalNotification {
                let alert = UIAlertController(title: localNoti.alertTitle, message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 테이블 뷰를 다시 읽어들인다
        listTableView.reloadData()
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return UIApplication.shared.scheduledLocalNotifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if let target = UIApplication.shared.scheduledLocalNotifications?[indexPath.row] {
            cell.textLabel?.text = target.alertTitle
            // fireDate : 런칭?하는 날짜 -> DateFormat해야함 반드시..
            // 나중에 10버전 코드로 바꿔보기
            cell.detailTextLabel?.text = target.fireDate?.description
        }
        
        return cell
    }
}


// 옆으로 밀어서 삭제 가능하도록
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // cell의 편집 스타일을 리턴 -> 스타일은 열거형
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // 취소를 탭하면 얘가 호출됨
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 대상 noti를 가져오는 것
            if let noti = UIApplication.shared.scheduledLocalNotifications?[indexPath.row] {
                // 얘는 배열로, 취소하면 자동적으로 배열에서 제거됨 -> 그리고 또! 테이블 뷰를 다시 읽어내야함
                UIApplication.shared.cancelLocalNotification(noti)
                
                
                // 테이블 뷰에서 셀을 제거하되 애니메이션효과로 자연스럽게
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "취소"
    }
}




















