
import UIKit

class DetailViewController: UIViewController {
    
    var course : Course?
    
    
    @IBOutlet weak var headerView: UIView!
    // 나중에 스크롤 올렸을때 title 보이게 나타내기 위함 용
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var blackBackButton: UIButton!
    @IBOutlet weak var whiteBackButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var listTableView: UITableView!
    
    // 상태변경 플래그
    var whiteMode = false
    
    var barStyle = UIStatusBarStyle.lightContent
    // ??????
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    @IBAction func moveToBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var floatingMenuTopConstraint: NSLayoutConstraint!
    var floatingMenuBase : CGFloat = 0.0
    
    lazy var df: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M월 d일(E)"
        return f
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(course)
        
        headerBackgroundView.alpha = 0
        blackBackButton.alpha = 0
        whiteBackButton.alpha = 1
        titleLabel.alpha = 0
        
        titleLabel.text = course?.title
        
        // 테이블 뷰 내부 여백 설정
        listTableView.contentInset = UIEdgeInsets(top: imageHeightConstraint.constant - headerView.bounds.height, left: 0, bottom: 0, right: 0)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if floatingMenuBase == 0.0 {
            let ip = IndexPath(row: 1, section: 0)
            if let cell = listTableView.cellForRow(at: ip) {
                let frame = view.convert(cell.frame, to: view)
                // 첫번째 셀까지 내려오는 위치 + 테이블 뷰의 높이?
                floatingMenuBase = frame.origin.y + listTableView.contentInset.top
                floatingMenuTopConstraint.constant = floatingMenuBase
            }
            
        }
    }
}



extension DetailViewController : UIScrollViewDelegate {
    // 스크롤 이벤트 처리
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print(y)
        
        // 스크롤에 따라 이미지 높이 변경
        let diff = y + 200
        
        floatingMenuTopConstraint.constant = floatingMenuBase - diff
        
        if y < -200 {
            // 스크롤 내릴 때?
            // 이미지 높이 + 바뀌는 스크롤 높이
            imageHeightConstraint.constant = 300 + abs(diff)
        } else {
            // 스크롤 올릴 때?
            // 이미지 높이 그대로
            imageHeightConstraint.constant = 300
        }
        
        // 스크롤에 따라 상단UI바 변경 & 한번만 실행(스크롤이 내려갈때마다 실행이 아니라)
        if y >= 0 {
            if !whiteMode {
                whiteMode = true
                
                // 스크롤 내릴 때
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.headerBackgroundView.alpha = 1
                    self.blackBackButton.alpha = 1
                    self.whiteBackButton.alpha = 0
                    self.titleLabel.alpha = 1
                }, completion: nil)
                
                
                // 바의 상태변경
                barStyle = .default
                setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            if whiteMode {
                whiteMode = false
                
                // 스크롤 올릴 때
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.headerBackgroundView.alpha = 0
                    self.blackBackButton.alpha = 0
                    self.whiteBackButton.alpha = 1
                    self.titleLabel.alpha = 0
                }, completion: nil)
                
                
                // 바의 상태변경
                barStyle = .lightContent
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
}









extension DetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseSummaryTableViewCell") as! CourseSummaryTableViewCell
            
            cell.titleLabel.text = course?.title
            cell.locationLabel.text = "강의실이다~~~~"
            cell.preparationLabel.text = "맥북만 가져와~~~~"
            
            if let start = df.string(for: course?.startDate), let end = df.string(for: course?.endDate) {
                cell.periodLabel.text = "\(start) ~ \(end)"
            }
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "dummy")!        }
    }
}



extension DetailViewController : UITableViewDelegate {
    // 핸들러로 높이 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 60
        case 2:
            return 1000
        default:
            return UITableViewAutomaticDimension
        }
    }
}


























