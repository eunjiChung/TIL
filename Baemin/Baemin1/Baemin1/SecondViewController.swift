
import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var headerBackgroundView: UIView!
    
    @IBOutlet weak var whiteBackButton: UIButton!
    
    @IBOutlet weak var blackBackButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    
    
    
    
    // 얘를 하기 전에 Info.plist에서 row를 하나 추가해줘야됨
    // .default = 검은색, .lightContent = 흰색 바
    // 얘를 동적으로 바꿀때는 다시 load해야됨
    var barStyle: UIStatusBarStyle = .default
    // 바 속성을 재정의하는 것. 흰색 혹은 검은색 밖에 안됨.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    @IBAction func moveBack(_ sender: Any) {
        // 화면을 팝한다, dismiss 아님
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 백그라운드의 배경 투명하게
        headerBackgroundView.alpha = 0
        blackBackButton.alpha = 0
        whiteBackButton.alpha = 1
        titleLabel.alpha = 0
        
        // 테이블 뷰를 이미지 바로 아래로 붙인다 -> top 200을 꼭 계산으로 해야되나...?
        listTableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        // 스크롤을 맞추기 위해...(???)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
        // 높이 맞춤
        listTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // flag
    var floatingMenuBase: CGFloat = 0.0
    
    // 얘는 콜백이라서 상위구현을 호출해야됨
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("===========") 얘가 두번 호출되기 때문에 플래그를 선언한다
        
        if floatingMenuBase == 0.0 {
            let ip = IndexPath(row: 1, section: 0)
            if let cell = listTableView.cellForRow(at: ip) {
                // 부모 뷰를 기준으로..
                let frame = view.convert(cell.frame, to: view)
                // 같이 움직일 애의 높이를 계산
                // 계산은 하나하나 지우고 시도해보기
                floatingMenuBase = frame.origin.y + listTableView.contentInset.top
                // 제약의 constant값을 바꿔줌
                top.constant = floatingMenuBase
            }
        }
    }
}

// tableview에 delegate 연결햇으니 자동으로 scroll delegate도 연결된 것
// 스크롤할 때마다 호출됨 -> 1point 움직일 때마다 삼백개씩 움직임이 생긴다
extension SecondViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y //현재 스크롤 포지션의 y값을 리턴함
//        print(y)    // 처음에는 200값이 출력되야함
        
        // 떠다니는 애가 움직일때마다 바뀜
        let diff = y + 200
        print(diff)
        
        if y < -200 {
            height.constant = 300 + abs(diff)
        } else {
            height.constant = 300
        }
        
        top.constant = floatingMenuBase - diff
        
        
        if y < 0 {
            barStyle = .lightContent
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                self.headerBackgroundView.alpha = 0
                self.blackBackButton.alpha = 0
                self.whiteBackButton.alpha = 1
                self.titleLabel.alpha = 0
            }, completion: nil)
        } else {
            barStyle = .default
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                self.headerBackgroundView.alpha = 1
                self.blackBackButton.alpha = 1
                self.whiteBackButton.alpha = 0
                self.titleLabel.alpha = 1
            }, completion: nil)
        }
        
        // bar를 다시 로드하는 것
        setNeedsStatusBarAppearanceUpdate()
        
    }
}








extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "cell")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummy")!
        
        // 두번째 셀은 파란색, 세번짹 셀은 빨간색으로 지정
        cell.contentView.backgroundColor = indexPath.row == 1 ? UIColor.blue : UIColor.red
        
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 3000 포인트의 셀이 표시됨 (???)
//        return 3000
        
        switch indexPath.row {
        case 0:
            // 자동으로 테이블 셀의 높이가 리턴
            return UITableViewAutomaticDimension
        case 1:
            return 60
        default:
            return 3000
        }
    }
}



















