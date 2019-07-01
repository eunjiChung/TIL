
import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard  let txt = inputField.text, txt.count > 0 else {
            return
        }
        
        let noti = UILocalNotification()
        noti.alertTitle = "알람이 도착했습니다!!!!!"
        noti.alertBody = txt
//        noti.fireDate = datePicker.date
        noti.fireDate = Date(timeIntervalSinceNow: 3)
        
        // 싱글톤 패턴
        noti.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        // Notification을 보낸다
        UIApplication.shared.scheduleLocalNotification(noti)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
