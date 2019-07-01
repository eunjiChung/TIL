
import UIKit

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func schedule(_ sender: Any) {
        guard let txt = inputField.text else {
            return
        }
        
        let noti = UILocalNotification()
        noti.alertTitle = txt
        
//      noti.fireDate = datePicker.date
        noti.fireDate = Date(timeIntervalSinceNow: 3)
        
        // 숫자를 전달해주면 오른쪽 위에 빨갛게 표시되고, 1씩 증가
        // 이렇게 쓰고나면 표시된 걸 어디선가 없애줘야함(AppDelegate)
        noti.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        
        UIApplication.shared.scheduleLocalNotification(noti)
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
