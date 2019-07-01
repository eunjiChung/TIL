
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var label: UILabel!
    
    var isStop = false
    
    
    let group = DispatchGroup()
    let queue1 = DispatchQueue(label: "1")
    let queue2 = DispatchQueue(label: "2")
    let queue3 = DispatchQueue(label: "3")
    
    
    @IBAction func stop(_ sender: Any) {
        isStop = true
    }
    
    @IBAction func start(_ sender: Any) {
        isStop = false
        progressView.progress = 0.0
        
        // 스레드를 다루고 싶을때????
        queue1.async {
            for _ in 1...10 {
                print("network")
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            self.queue2.async {
                for _ in 1...10 {
                    print("database")
                    Thread.sleep(forTimeInterval: 0.1)
                }
                
                self.queue3.async {
                    for _ in 1...10 {
                        print("ui update")
                        Thread.sleep(forTimeInterval: 0.1)
                    }
                }
            }
        }
        
        // ?????? 얘를 먼저 실행하고 싶을때?
        group.notify(queue: DispatchQueue.main) {
            print("Done")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

