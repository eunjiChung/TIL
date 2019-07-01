/*
  1. Segue말고 SingleTone으로 데이터를 전달하는 화면
  2. Notification 패턴
  3. Delegate로 전달하는 패턴
 
  -> 많이 쓰는건 SingleTon
  -> 가능하다면 Notification이 좋긴하다

 */

import UIKit



// 1.
// 원래 새로운 파일에 만들지만 오늘은 그냥 여기다가 만듦
// SingleTone은 반드시 하나의 인스턴스만 만들어야함
// 얘는 프로젝트 전체에서 접근 가능
class ValueStore {
    var strValue: String?
    
    // 얘를 통해서만 작동할 수 있음
    static let shared: ValueStore = ValueStore()
    
    // 이 private init 생성자를 만들어주면 더이상 외부에서 ValueStore 생성 불가능
    // type property에 처음 접근할때 단 하나의 인스턴스가 만들어진다(????)
    private init() {
        
    }
}




// 2.
// Notification 만들때 따르는 형식
// 하나의 앱 내에서 이름이 중복되면 안됨.
// Notification 하나당 고유한 이름을 가지고 있어야함
let ValueDidInputNotification = Notification.Name(rawValue: "ValueDidInputNotification")




// 3. Delegation Pattern
// @objc는 Optional 타입이 되는 protocol
@objc protocol Sendable {
    @objc optional func valueDidInput(value: String)
}




class SecondViewController: UIViewController {
    
    
    // 3. 뭐하는건지 모르겠으...
    var delegate: Sendable?
    
    
    

    
    @IBOutlet weak var inputField: UITextField!
    
    @IBAction func sendValue(_ sender: Any) {
        // 값 가져오기
        guard let txt = inputField.text else {
            fatalError()
        }
        
        
        ///// 1,
        // 접근
        // 접근이 불가능한거 아닌가? 응?
//        ValueStore.shared.strValue = txt
        
        
        
        
        
        /////// 2.
        // Notification은 마치 편지 같은것
        // NotificationCenter는 편지를 받아주는 우체국 같은 것
        // AddObserver : 편지 받아서 뜯을때. Post된거는 BroadCast이기 때문에 앱 내에서 observer만 있으면 다 받을 수 있음
        // Post : 편지 보낼때
//        NotificationCenter.default.post(name: ValueDidInputNotification, object: txt)
        
        
        
        
        ////// 3.
        // optional chaining
        delegate?.valueDidInput?(value: txt)
        
        
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
}
