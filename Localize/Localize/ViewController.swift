
//
// 앱 지역화하는 필수테크닉
// 얘의 기본 언어는 영어 -> 한글로 바꾸고 싶으면?

//
// **Info.plist에서 첫번째를 Korea로 수정(이제 모든게 한글로 표시됨)
// 이건 앱 스토어에 출시할 때 한글로 출시하고 싶으면 이렇게 언어설정해주는 것
//


//
// **그냥 Edit Scheme에서 가능하게 만드는 법.
// 맨처음 Project Localizations에서 언어를 추가해준다
// 그냥 그대로 Korean 추가 -> Edit Scheme에서 바꾸기만 해도 적용된다
//

//
// (************)지역화 작업은 맨 마지막에 한다(*************)
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func update(_ sender: Any) {
        label.text = NSLocalizedString(label.text!, comment: "")
        label.text = title
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지역화하는 법 -> 매크로 사용
        let title = NSLocalizedString("Click", comment: "")
        btn.setTitle(title, for: .normal)
        
        
        
        // 지역화를 가장 단순하게 하는법 -> 매번 언어 추가해줘야해서 비효율적
//        if 영어 {
//            btn.setTitle("Button", for: .normal)
//        } else {
//            btn.setTitle("버튼", for: .normal)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

























