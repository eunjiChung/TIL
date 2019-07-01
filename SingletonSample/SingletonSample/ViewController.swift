/*
 
 1. 이전에는 segue로 데이터를 화면끼리 주고받았는데
 이제는 singletone 패턴으로 주고 받는 것으로 한다

 버튼을 눌러서 다음화면으로 넘어가는게 아님
 코드로 segue로 넘어가는 걸 만들것
 
 2. Notification으로 전달하는 것(Notification의 종류에는 여러가지가 있음)
 
 3. Delegate Pattern
 
 
 */

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!
    
    // Target Action Pattern
    @IBAction func moveToSecond(_ sender: Any) {
        // sender : segue를 실행시키는 애, 이벤트를 전달하는 애를 의미
        // 버튼을 눌러서 실행할거면 sender에 변수를 넣지만 지금은 그게 아니므로 nil을 입력
        // 얘는 주로 로그인 누를 때 네트워크로 무언가를 전송하면서 여러가지 segue를 분기시킬때 쓴다
        // segue를 여러개 쓸때 이용하는 패턴!!!!!!!!!!!!!!
        performSegue(withIdentifier: "second", sender: nil)
    }
    
    
    
    // 3.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SecondViewController {
            vc.delegate = self
        }
    }
    
    
    
    // 얘는 한번만 호출됨
    // 처음 화면 나타날때 생성된 것..다음 화면으로 넘어가도 사라지지 않고 아래 깔려있다
    // 값을 받아오는 건 다른애가 해야됨 -> viewWillAppear (화면이 표시되기 직전에 매번 UIKit에 의해 호출되기 때문)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 2.
        // forName: 우리가 받아서 처리할 Notification 이름
        // 화면 업데이트는 늘 메인 스레드에서 실행 -> Queue는 스레드랑 동일하다고 생각하면 됨
        
        // 상당히 많이 쓰이는 Notification Pattern -> 얘는 사용자가 반드시 로그인을 해야할 때 씀
        // 사용자 정보를 캐싱했지만, 로그인을 못했을 떄 얘를 사용함
        
        // noti는 무엇?
//        NotificationCenter.default.addObserver(forName: ValueDidInputNotification, object: nil, queue: OperationQueue.main) { (noti) in
//            if let str = noti.object as? String {
//                self.valueLabel.text = str
//            }
//        }
        
        print(UIScreen.main.bounds) // 이거 궁금했는데,,ㅎㅎ
        print(UIScreen.main.scale)  // 아이폰X은 @3x
        
        
        // iOS 11에서만 쓰기 가능 : view.safeAreaInsets
        // 밑에는 Fix한 것
        // 얘의 의미는 알아야함.. 뭔디?
        if #available(iOS 11.0, *) {
            view.safeAreaInsets
        } else {
            // Fallback on earlier versions
        }
        
        
        // 시뮬레이터와 실제 핸드폰 코드 분기시키기
        // 앞에 붙은 #은 전처리기(?)
        
        // ******************************************
        // 앞으로 자주쓰는 shortcut은 지정해준다!!!!!!!!!!1
        // 생산성이 올라감..
//        #if (arch(i386) || arch(x86_64)) && os(iOS)
//            // 시뮬레이터 실행시 코드 넣는 곳
//            <#SimulatorCode#>
//        #else
//            <#DeviceCode#>  // 디바이스 실행시 코드 넣는 곳
//        #endif
        
        
        // PlaceHolder -> <#
        // #>
        
        
        // 디버그 모드 vs 릴리즈 모드 -> 차이????????
        
        test()
        test()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1.
//        valueLabel.text = ValueStore.shared.strValue
    }
}




// 3. 프로토콜 사용하는 방법
// 재밌다~~
// 근데 이해가 안된다
extension ViewController: Sendable {
    func valueDidInput(value: String) {
        valueLabel.text = value
    }
    
    
}














