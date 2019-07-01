
import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let text = inputField.text, text.count > 0 else {
            return
        }
        
        let noti = UILocalNotification()
        noti.alertTitle = "알림"
        noti.alertBody = text
        noti.fireDate = datePicker.date
        noti.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        UIApplication.shared.scheduleLocalNotification(noti)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
