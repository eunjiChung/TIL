
import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var label: UILabel!
    
    var isStop = false
    @IBAction func stop(_ sender: Any) {
        isStop = true
    }
    
    @IBAction func start(_ sender: Any) {
        isStop = false
        progressView.progress = 0.0
        
        DispatchQueue.global().async {
            var sum = 0
            
            for i in 1...100 {
                
                if self.isStop {
                    return
                }
                
                sum += i
                
                DispatchQueue.main.async {
                    self.progressView.progress = Float(Double(i) * 0.01)
                    self.label.text = "\(i) : \(sum)"
                }
                
                // 텀을 둔다
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            DispatchQueue.main.async {
                self.label.text = "\(sum)"
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

