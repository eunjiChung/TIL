
import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var label: UILabel!
    
    
    // flag
    var isStop = false
    
    @IBAction func stop(_ sender: Any) {
        isStop = true
    }
    
    @IBAction func start(_ sender: Any) {
        isStop = false
        progressView.progress = 0.0
        
        DispatchQueue.global().async {
            
            var sum = 0
            
            // 1. 계산되는 동안...
            for i in 1...100 {
                
                // closure 안에서 바깥의 플래그를 호출시, self를 붙인다
                if self.isStop {
                    return // global 스레드를 끝내는 것?
                }
                
                sum += i
                
                // 결과가 나타나려면 메인 스레드에서 UI를 고쳐줘야함
                DispatchQueue.main.async {
                    self.progressView.progress = Float(Double(i) * 0.01)
                    self.label.text = "\(i) : \(sum)"
                }
                
                // 텀을 두고 나타내기 위해
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            // 2. 계산이 끝날 경우
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



















