
import UIKit


// 왜 꼭 Date 클래스 확장해서?? 그냥 이렇게 사용할 수 있다는걸 나타내려고?
extension Date {
    func diffString(for date: Date) -> String? {
        let cal = Calendar.current
        let comp = cal.dateComponents([.day], from: self, to: date)
        
        if let day = comp.day {
            let fm = NumberFormatter()
            fm.numberStyle = .decimal
            return fm.string(for: day)
        }
        
        return nil
    }
}


class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        // 1. 선택된 날짜 받아오기
        let selectedDate = sender.date
        // 2. resultLabel에 날짜 나타내기
        UIView.animate(withDuration: 0.5) {
            self.resultLabel.text = Date().diffString(for: selectedDate)
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom baseDate 설정
//        if let picker = view.viewWithTag(100) as? UIDatePicker {
//            let baseDate = Date(timeIntervalSinceNow: 3600 * 24 * 10)
//            picker.date = baseDate
//
//            resultLabel.text = Date().diffString(for: picker.date)
//        }
    }
}

























