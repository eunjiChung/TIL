

import UIKit

// ViewController는 하나의 씬을 관리 -> 라이프 사이클이 존재
// Load -> Appear/Disappear -> Unload
class SecondViewController: UIViewController {

    var urlString: String?
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // 이 두개는 직접 활성화시킬 것 (슬랙 애니메이션을 위해 받아옴)
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    
    @IBAction func goBack(_ sender: Any) {
        // 여기선 화면을 푸시했기 때문에 dismiss하면 안됨
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottom.isActive = false
        centerY.isActive = true
        titleLabel.alpha = 0.0
        view.layoutIfNeeded()
    }

}




// 몇 번 해보면 간단함
// 다시한번 몇번씩 해보기 -> 패턴 사이트에서 50개 정도 따라하면 파악이 될 것임
extension SecondViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        UIView.animate(withDuration: 0.3) {
            if finalText.count > 0 {
                self.bottom.isActive = true
                self.centerY.isActive = false
                self.placeholderLabel.alpha = 0.0
                self.titleLabel.alpha = 1.0
            } else {
                self.bottom.isActive = false
                self.centerY.isActive = true
                self.placeholderLabel.alpha = 1.0
                self.titleLabel.alpha = 0.0
            }
            self.view.layoutIfNeeded()
        }
        
        return true
    }
}


























