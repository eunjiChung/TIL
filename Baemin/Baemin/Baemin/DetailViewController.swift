
import UIKit

class DetailViewController: UIViewController {
    
    lazy var df: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M월 d일(E)"
        return f
    }()

    // 전달된 데이터 받을 변수
    var course : Course?
    
    @IBOutlet weak var headerBackgroundView: UIView!
    
    @IBOutlet weak var blackBackButton: UIButton!
    
    @IBOutlet weak var whiteBackButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBAction func moveToBack(_ sender: Any) {
        // 애니메이션 효과가 저절로 적용되는거?
        navigationController?.popViewController(animated: true)
    }
    
    var whiteMode = false
    
    var barStyle = UIStatusBarStyle.lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    
    @IBOutlet weak var floatingMenuTopConstraint: NSLayoutConstraint!
    var floatingMenuBase: CGFloat = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 여기서 전달된 데이터 확인
//        print(course)
        
        headerBackgroundView.alpha = 0
        blackBackButton.alpha = 0
        whiteBackButton.alpha = 1
        titleLabel.alpha = 0
        // 전달받은 데이터로 제목 설정
        titleLabel.text = course?.title
        
        
        // ???????????????????????
        listTableView.contentInset = UIEdgeInsets(top: imageHeightConstraint.constant - headerView.bounds.height, left: 0, bottom: 0, right: 0)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
        
    }
    
    
    // ?????
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if floatingMenuBase == 0.0 {
            let ip = IndexPath(row: 1, section: 0)
            if let cell = listTableView.cellForRow(at: ip) {
                let frame = view.convert(cell.frame, to: view)
                floatingMenuBase = frame.origin.y + listTableView.contentInset.top
                floatingMenuTopConstraint.constant = floatingMenuBase
            }
        }
    }

}


extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 좌표를 가져오는 것
        let y = scrollView.contentOffset.y
        print(y)
        
        let diff = y + 200
        
        floatingMenuTopConstraint.constant = floatingMenuBase - diff
        
        
        // 스크롤에 따른 이미지 높이 변경
        if y < -200 {
            imageHeightConstraint.constant = 300 + abs(diff)
        } else {
            imageHeightConstraint.constant = 300
        }
        
        
        if y >= 0 {
            if !whiteMode {
                whiteMode = true
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { [weak self] in
                    self?.headerBackgroundView.alpha = 1.0
                    self?.blackBackButton.alpha = 1.0
                    self?.whiteBackButton.alpha = 0.0
                    self?.titleLabel.alpha = 1.0
                    }, completion: nil)
                
                barStyle = .default
                setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            if whiteMode {
                whiteMode = false
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { [weak self] in
                    self?.headerBackgroundView.alpha = 0.0
                    self?.blackBackButton.alpha = 0.0
                    self?.whiteBackButton.alpha = 1.0
                    self?.titleLabel.alpha = 0.0
                    }, completion: nil)
            }
            
            
            barStyle = .lightContent
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}





extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "dummy")!
//
//        return cell
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseSummaryTableViewCell.identifier) as! CourseSummaryTableViewCell
            
            cell.titleLabel.text = course?.title
            if let start = df.string(for: course?.startDate), let end = df.string(for: course?.endDate) {
                cell.periodLabel.text = "\(start) ~ \(end)"
            }
            cell.timeLabel.text = "화요일, 목요일 19:30 ~ 22:30"
            cell.preparationLabel.text = "Xcode 9이 설치된 Mac"
            cell.locationLabel.text = course?.location
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "dummy")!
        }
    }
}



// ??????
// 셀은 있지만 테이블 배경이 투명
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 3000
        
        switch indexPath.row {
        case 1:
            return 40
        case 2:
            return 1000
        default:
            return UITableViewAutomaticDimension
        }
    }
}














































