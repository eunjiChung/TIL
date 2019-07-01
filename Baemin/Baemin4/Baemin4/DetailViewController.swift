
import UIKit

class DetailViewController: UIViewController {
    
    var course : Course?
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var blackBackButton: UIButton!
    @IBOutlet weak var whiteBackButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    
    // flag
    var whiteMode = false
    var barStyle = UIStatusBarStyle.lightContent
    
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

        // 0이 안보이게, 1이 보이게
        headerBackgroundView.alpha = 0
        blackBackButton.alpha = 0
        whiteBackButton.alpha = 1
        titleLabel.alpha = 0
        titleLabel.text = course?.title
        
        listTableView.contentInset = UIEdgeInsets(top: imageHeightConstraint.constant - headerView.bounds.height, left: 0, bottom: 0, right: 0)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
    }

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


extension DetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
//        print(y)
        
        let diff = y + 200
        
        floatingMenuTopConstraint.constant = floatingMenuBase - diff
        
        if y < -200 {
            // 테이블을 내릴때 -> 화면 높이에 변화가 온다
            imageHeightConstraint.constant = 300 + abs(diff)
        } else {
            // 테이블을 올릴때 -> 화면 높이가 그대로
            imageHeightConstraint.constant = 300
        }
        
        if y >= 0 {
            if !whiteMode {
                whiteMode = true
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.headerBackgroundView.alpha = 1
                    self.blackBackButton.alpha = 1
                    self.whiteBackButton.alpha = 0
                    self.titleLabel.alpha = 1
                }, completion: nil)
                
                barStyle = .default
                setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            if whiteMode {
                whiteMode = false
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.headerBackgroundView.alpha = 0
                    self.blackBackButton.alpha = 0
                    self.whiteBackButton.alpha = 1
                    self.titleLabel.alpha = 0
                }, completion: nil)
                
                
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
            cell.timeLabel.text = "Every Tue, Wed 19:30~22:30"
            cell.preparationLabel.text = "MacBook with Xcode9 installed"
            cell.locationLabel.text = course?.location
            
            if let start = df.string(for: course?.startDate), let end = df.string(for: course?.endDate) {
                cell.periodLabel.text = "\(start) ~ \(end)"
            }
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "dummy")!
        }
    }
}





extension DetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 1:
            return 60
        case 2:
            return 1000
        default:
            // 자동으로 셀 높이를 조절 -> 맨 첫번째 셀에 적용된다
            return UITableViewAutomaticDimension
        }
    }
}






























