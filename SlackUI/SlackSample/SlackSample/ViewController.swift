//
//  ViewController.swift
//  SlackSample
//
//  Created by CHUNGEUNJI on 2018. 1. 24..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//


// Nav Controller 추가 : 신 독 클릭, Editor->Embed in->Nav bar 선택
import UIKit

class ViewController: UIViewController{
    
    
    // 8. 첫화면 텍스트가 세 개 들어감
    // 첫번째 텍스트 필드 -> 경계를 None으로 하면 height를 지정해줘야함
    // 그리고 뒷배경에 깔아주는 건 Placeholder인데...얘는 정적이다
    // 동적으로 바꾸려면 뒤에 하나 깔아줘야됨
    // 9. 라벨 두개 추가
    // 위에 있는 라벨 -> 아래 텍스트 필드랑 Vertical Spacing & Leading 맞춰줌. 그리고 Constant를 10으로 맞춰줌(선 선택해서 수정)
    // 10. 밑바탕으로 깔리는 라벨 -> placeholder처럼 보이는 애
    // 왼쪽 View Controller Scene에서 얘를 텍스트 필드 위로 놔야함
    // 얘는 텍스트 필드의 크기와 맞춰야함
    // 11. placeholder 이벤트 처리하는 것
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    // 12. 텍스트 필드가 변경되는 시점을 잡아야함 ->  delegate를 써야함 -> textField를 ViewControllor에 delegate를 연결해줌
    // 이제는 extension을 써서 따로 해준다
    
    
    
    // 1. 아래 문장 Outlet으로 추가. NS -> 제약사항을 나타냄
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    
    // 뷰가 호출되기 이전에 호출
    // 얘는 UIKit이 이 화면을 관리하면서 호출(...?)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 17. next button 비활성화 초기화
        nextButton.isEnabled = false
        
        // 3. 지금부터 2초뒤에 closure 안에서 실행(이 문법은 closure임!!!!)
        // 그리고 dispatchQueue는 스레드의 일종(나중에 배움..지금은 그냥 쓰기)
        // closure 안에서 실행될 때는 반드시 self를 붙여줘야함
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //            // 4. 이건 주로 많이 나오는 애니메이션 -> 애니메이션으로 올라가는 작업이 실행됨
        //            // 이제 키패드가 올라오거나 내려가는 시점만 잡으면 됨 -> 이건 delegate Pattern을 쓸 수 있지만
        //            // remote notification을 쓰겠음!! (예) 카톡 알림
        //            // local notification (예) 알람
        //            // 그냥 일반 notification -> 아래에 새로 쓸 것
        //            UIView.animate(withDuration: 0.3, animations: {
        //                // 2. Bottom의 아래 space를 임의로 바꿔줌
        //                self.bottom.constant = 100
        //                // 변경사항이 있으면 재배치할 것!!을 의미. 제약을 호출하면 반드시 이걸 한번 호출해줘야됨(***)
        //                self.view.layoutIfNeeded()
        //            })
        //        }
        
        
        
        // 5. Notification 사용 -> 키보드의 시점을 잡아서 알린다
        // Observer Pattern(???)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            // 6. 키보드 높이 알아내기 -> 아이폰에서 키보드 높이는 가변이라서 높이를 고정시키면 안됨
            // 그 외에 복잡한 과정이 있지만,,,,개발자 문서에도 잘 안나오는데 어떻게 아냐면
            // 이 코드를 기준으로 그냥 UIKeyboardFrameEndUserInfoKey 같이 잘 안나오는걸
            // cmd + 클릭한다 -> Jump to definition
            if let value = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = value.cgRectValue
                let height = keyboardFrame.height
                
                // 얘는 애니메이션 블록 바로 위에 놓는다. 안에 넣어도 상관없지만, 일단 이렇게...
                self.bottom.constant = height + 20 // 20은 그냥 추가여백
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded() // 뷰 강제 업데이트(****) 작업 후 반드시 해주자
                })
            }
        }
        
        // 팁*) 자동정렬 -> cmd + A -> ctrl + i
        
        
        // 7. UIKeyboardWillShow했으니 UIKeyboardWillHide 해줄 차례
        // 근데 UIKeyboardDidShow도 동작하던데.....
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (noti) in
            // 원래 20대신 스토리보드에서 의도했던 bottom을 넣어야함
            // 원래 이렇게 20 생짜 숫자로 넣으면 안됨 -> 계산해온 값을 넣어줘야함
            self.bottom.constant = 20
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    // segue가 실행되기 직전에 실행
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SecondViewController {
            vc.urlString = (inputField.text ?? "") + placeholderLabel.text!
        }
    }
    
    
    
    
}

// 13. Delegate 만들어주기
// 얘는 논리적 오류가 있는 코딩 -> 도전과제!!!!
// range에 삭제되거나 추가되는 범위가 넘어온다. 따라서 range를 이용해서 string을 replace해야됨
// NSString이 힌트 (뭔 힌트...?) -> replacingCharacters 이용 (Document에 나옴)
// 얘는 TextField가 입력받기 직전에 호출 -> True면 이벤트 처리
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 텍스트 필드 값이 변경될 때마다 매번 호출
        // should니까 변경하기 전에 물어봐서 호출 된다-> true면 값을 입력
        // 입력값이 한번씩 밀려서 적용되기 때문에 그걸 해결해야 함
        // finalText 익숙해지도록 만들기
        let finalText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string) // nil operator (???)
        
        
        
        
        
        
        
        
        
//        if string.count == 0 {
//            // 이건 String 부분
//            let startIndex = finalText.startIndex
//            // 인덱스 사용시 위치 혼동 주의!!!! (사실 여기 오류났던 부분 이해못함ㅎㅎ)
//            // String 다룰 때 오류가 많이 나므로 노트에 그리면서 하기
//            let endIndex = finalText.index(finalText.endIndex, offsetBy: -1)
//            // 문자열 중간을 추출한 애들은 자료형이 Substring 형이라서
//            // 다시 String형으로 한번 바꿔줘야됨 (다시 보기)
//            finalText = String(finalText[startIndex..<endIndex])
//        } else {
//            // append(대상을 직접 변경) VS appending(직접 변경하지 않고 새로운 문자열 리턴)
//            // 그러면 적절한 거 사용은 어떻게 알지?
//            finalText = finalText.appending(string)
//        }
        
//        print(finalText)
        // 14. 입력된 텍스트의 너비를 구해서 텍스트 수정
        let nsstr = finalText as NSString
        // 텍스트 필드의 폰트크기를 따온다 -> inputField
        let dict = [NSAttributedStringKey.font: inputField.font!]
        // 딕셔너리의 너비를 상수에 저장
        let width = nsstr.size(withAttributes: dict).width
        leading.constant = width
        view.layoutIfNeeded()
        
        // 15. your-slack을 빼고 더해주기
        // 자칫 노가다 같지만 어쨋든 이쁘게 하려면 다 이렇게 이루어진다...
        
        // 16. 마지막!!! Next 버튼
        // 활성화된 상태(State) -> Enabled
        // 얘는 텍스트 필드에 한 글자라도 입력되면 활성화, 초기엔 비활성화
        
        // 반드시 NotificationCenter라는 문서를 보기(한글문서봐도 됨)
        if finalText.count == 0 {
            placeholderLabel.text = "your-url.slack.com"
            nextButton.isEnabled = false
        } else {
            placeholderLabel.text = ".slack.com"
            nextButton.isEnabled = true
        }
        
        return true
    }
    
}






















