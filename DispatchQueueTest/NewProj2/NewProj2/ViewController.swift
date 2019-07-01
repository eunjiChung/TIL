
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
        
        // 계산은 백그라운드에서?
        // Start 액션은 액션대로, 액션에서 파생된 스레드는 스레드대로 흘러간다
        DispatchQueue.global().async {
            var sum = 0
            
            for i in 1...100 {
                if self.isStop {
                    return
                }
                
                sum += i
                
                DispatchQueue.main.async {
                    // 아, progress의 비율을 맞추기 위해서
                    self.progressView.progress = Float(Double(i) * 0.01)
//                    self.progressView.progress = Float(Double(i))
                    self.label.text = "\(i) : \(sum)"
                }
                
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






















