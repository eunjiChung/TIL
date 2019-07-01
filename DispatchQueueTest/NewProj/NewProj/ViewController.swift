/*
 
 오늘의 주제 : 스레드와 지역화
 1부터 100까지 단계적으로 업데이트 하는게 목적
 스레드 => DispatchQueue.global, DispatchQueue.main
 스레드는 이게 다임!!!!!!!!!!!!!!!!!!!!!!!1111
 
 보통 싱크를 맞추기 위해 Semaphore나 Lock을 쓰지만
 swift는 다른걸 씀
 
 */

import UIKit

class ViewController: UIViewController {
    
    //동기화를 위해 락이 아니라
    // 1. private으로 바꾼다
    // 2. lock을 걸 queue를 만든다
    // 3. 계산속성을 만든다 -> lock 필요없고 그냥 얘 쓰기
    // 하지만 가장 좋은건 RSSwift가 제일 나음
    let lockQueue = DispatchQueue(label: "lock")
    
    // 동기화할 애를 private으로 만듦
    private var value: String = ""
    var publicValue: String{
        get {
            return lockQueue.sync {
                return value
            }
        }
        set {
            lockQueue.sync {
                value = newValue
            }
        }
    }
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var label: UILabel!
    
    // 플래그 선언
    var isStop = false
    
    let group = DispatchGroup()
    let queue1 = DispatchQueue(label: "1")
    let queue2 = DispatchQueue(label: "2")
    let queue3 = DispatchQueue(label: "3")
    
    @IBAction func stop(_ sender: Any) {
        isStop = true
    }
    
    @IBAction func start(_ sender: Any) {
        
        // Start3 스레드의 우선순위 정하기
        let d = DispatchQueue(label: "elfiaeoifj", qos: .background)
        
        // Start2
        // 비동기적으로 실행된다
        // But, 실행순서를 컨트롤 할 수 없다 & 동시 실행
        // 그래서 group 안쓰고 중첩으로 해줌 => 하지만 현업에서는 이렇게 쓰면 안됨
        // 하지만 현업가면 이거말고 -> RSSwift 쓰기
        queue1.async {
            for _ in 1...10 {
                print("network")
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            self.queue2.async {
                for _ in 1...10 {
                    print("database")
                    Thread.sleep(forTimeInterval: 0.5)
                }
                
                self.queue3.async  {
                    for _ in 1...10 {
                        print("ui update")
                        Thread.sleep(forTimeInterval: 0.7)
                    }
                }
            }
        }
        
        
        
        
        
        // 얘를 맨 마지막에 실행하고 싶다면?
        // 위 큐들을 모두 그룹으로 묶는다
        // 그리고 done을 마지막에 하기 위해 notify사용 -> execute코드에 실행할 것 넣기
        group.notify(queue: DispatchQueue.main) {
            print("Done")
        }
        
        
        
        
        // 여기서부터 주석처리
        
        // Start 1 -> 이 패턴을 기억하면 됨!!!!!!!!!!!!!!!!!
        // 초기화
//        progressView.progress = 0.0

        // UI를 업데이트하는건 메인스레드에서 행해져야 함
        // 메인스레드는 GCD에서 Main.Queue라고 함
        // 그게 바로 DispatchQueue.main
        // 그 외가 바로 DispatchQueue.global()이 다른 스레드
        // 이 안의 모든 코드는 백그라운드에서 실행됨
        
        // closure인데 이 안에서 outlet에 접근하려면 반드시 self를 붙여줘야함
        // 단 업데이트는 계속 메인스레드에서 실행되어야 함

        // 60프레임(???)이 넘어갈 것 같은 코드는 모두 global queue에 넣는다
        // 하지만 취소는 할 수 없음 => Queue는 넣으면 끝임
//        DispatchQueue.global().async {
//            var sum = 0
//            for i in 1...100 {
//                // 취소코드 구현
//                // NSOperation을 이용할 수도 있음 -> 수업땐 안함
//                if self.isStop {
//                    return
//                }
//
//                sum += i
//
//                // 얘는 메인스레드에서 실행되어야함
//                // 이제 얘는 메인에서 실행되는 것
//                // DispatchQueue는 얼마든지 중복가능
//                DispatchQueue.main.async {
//                    self.progressView.progress = Float(Double(i) * 0.01)
//                    self.label.text = "\(i) : \(sum)"
//                }
//
//                Thread.sleep(forTimeInterval: 0.1)
//            }
//
//            DispatchQueue.main.async {
//                self.label.text = "\(sum)"
//            }
//        }
//
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

