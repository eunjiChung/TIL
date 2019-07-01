
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftInputField: UITextField!
    
    @IBOutlet weak var rightInputField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dict = [String: Int]()
    var keys: [String]?
    
    
    @IBAction func addAction(_ sender: Any) {
        // key & value를 받아온다
        guard let keyStr = leftInputField.text, keyStr.count > 0 else {
            return
        }
        guard let valueStr = rightInputField.text, valueStr.count > 0, let num = Int(valueStr) else {
            return
        }
        
        // key와 value를 dict에 붙여넣는다
        dict[keyStr] = num
        keys = Array(dict.keys).sorted()
        
        tableView.reloadData()
        leftInputField.text = ""
        rightInputField.text = ""
        
        if leftInputField.isFirstResponder {
            leftInputField.resignFirstResponder()
        }
        if rightInputField.isFirstResponder {
            rightInputField.resignFirstResponder()
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if let targetKey = keys?[indexPath.row], let targetValue = dict[targetKey] {
            cell.textLabel?.text = "\(targetKey)"
            cell.detailTextLabel?.text = "\(targetValue)"
        }
        
        return cell
    }
    
    
}
















