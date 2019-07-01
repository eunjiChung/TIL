
import UIKit

class ComposeViewController: UIViewController {
    
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let text = inputField.text, text.count > 0 else {
            return
        }
        
        let noti = UILocalNotification()
        noti.alertTitle = "알림이 도착했습니다"
        noti.alertBody = text
        noti.fireDate = Date(timeIntervalSinceNow: 5)
        noti.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        UIApplication.shared.scheduleLocalNotification(noti)
        
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
