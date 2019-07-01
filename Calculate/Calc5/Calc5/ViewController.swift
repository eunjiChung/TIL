
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftInput: UITextField!
    @IBOutlet weak var rightInput: UITextField!
    @IBOutlet weak var opField: UITextField!
    
    func processResult() -> String? {
        guard let leftText = leftInput.text, leftText.count > 0, let leftNum = Int(leftText) else {
            return nil
        }
        
        guard let op = opField.text, op.count > 0 else {
            return nil
        }
        
        guard let rightText = rightInput.text, rightText.count > 0, let rightNum = Int(rightText) else {
            return nil
        }
        
        var result = 0
        
        switch op {
        case "+":
            result = leftNum + rightNum
        case "-":
            result = leftNum - rightNum
        case "*":
            result = leftNum * rightNum
        case "/":
            result = leftNum / rightNum
        default:
            doAlert(title: "WARNING", msg: "판별할 수 없는 부호")
            return nil//****
        }
        
        return "\(leftNum) \(op) \(rightNum) = \(result)"
    }
    
    @IBAction func doCalc(_ sender: Any) {
        guard let msg = processResult() else {
            return
        }
        
        doAlert(title: "결과", msg: msg)
        leftInput.text = ""
        rightInput.text = ""
        opField.text = ""
    }
    
    func doAlert(title: String, msg: String) {
        // UIAlertController
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        // UIAlertAction
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultViewController {
            vc.msg = processResult()
        }
    }

}





















