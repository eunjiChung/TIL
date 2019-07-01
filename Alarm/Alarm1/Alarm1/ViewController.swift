
import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var listTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        listTableView.reloadData()
        
        
        // Observer를 두고 꾸준히 뷰를 업데이트시켜준다
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main) { (noti) in
            self.listTableView.reloadData()
        }
    }
    
    
    // 이미 앱이 한번 실행된 상태에서는 호출되지 않는다
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.reloadData()
    }
    
    
    
    
    var df : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f
    }()
}


extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIApplication.shared.scheduledLocalNotifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if let list = UIApplication.shared.scheduledLocalNotifications {
            let target = list[indexPath.row]
            cell.textLabel?.text = target.alertBody
            cell.detailTextLabel?.text = df.string(for: target.fireDate)
        }
        
        return cell
    }
}




extension ViewController : UITableViewDelegate {
    // 행을 수정할 수 있는가? -> 네
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 수정할 스타일 지정
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // 지정한 스타일 별 동작 수행
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let list = UIApplication.shared.scheduledLocalNotifications {
                let target = list[indexPath.row]
                
                UIApplication.shared.cancelLocalNotification(target)
                tableView.reloadData()
            }
        default:
            break
        }
    }
}

























