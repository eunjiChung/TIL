
import UIKit

class DetailViewController: UIViewController {
    
    var course : Course?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var whiteBack: UIButton!
    @IBOutlet weak var blackBack: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    var barStyle = UIStatusBarStyle.lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    
    @IBOutlet weak var floatingMenuTopConstraint: NSLayoutConstraint!
    var floatingMenuBase : CGFloat = 0.0
    
    
    // global 영역이 나뉘어져 있나??
    lazy var df : DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M월 d일(E)"
        return f
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(course)
        
        headerBackgroundView.alpha = 0
        titleLabel.alpha = 0
        // alpha값이 1이면 투명해짐?
        blackBack.alpha = 0
        // alpha값이 0이면 불투명
        whiteBack.alpha = 1
        titleLabel.text = course?.title
        
        listTableView.contentInset = UIEdgeInsets(top: imageHeightConstraint.constant - headerView.bounds.height, left: 0, bottom: 0, right: 0)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
    }
    
    
    // ??????
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if floatingMenuBase == 0.0 {
            let ip = IndexPath(row: 1, section: 0)
            if let cell = listTableView.cellForRow(at: ip) {
                // view???? : 컨트롤러가 관리하는 뷰 == DetailView?
                let frame = view.convert(cell.frame, to: view)
                // ???? 뭘 더한거야
                floatingMenuBase = frame.origin.y + listTableView.contentInset.top
                floatingMenuTopConstraint.constant = floatingMenuBase
            }
        }
    }
}


var whiteMode = false

extension DetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        let diff = y + 200
        
        floatingMenuTopConstraint.constant = floatingMenuBase - diff
        
        if y < -200 {
            imageHeightConstraint.constant = 300 + abs(diff)
        } else {
            imageHeightConstraint.constant = 300
        }
        
        if y >= 0 {
            if !whiteMode {
                whiteMode = true
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.headerBackgroundView.alpha = 1
                    self.titleLabel.alpha = 1
                    self.blackBack.alpha = 0
                    self.whiteBack.alpha = 1
                }, completion: nil)
                
                
                barStyle = .default
                setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            if whiteMode {
                whiteMode = false
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.headerBackgroundView.alpha = 0
                    self.titleLabel.alpha = 0
                    self.blackBack.alpha = 1
                    self.whiteBack.alpha = 0
                }, completion: nil)
                
                
                barStyle = .lightContent
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
}




extension DetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 셀이 두개...? 셀 당 3개씩 리턴???
        // 왜 3?
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tableView.dequeueReusableCell(withIdentifier: "dummy")!
        
        switch indexPath.row {
        case 0:
            // 첫번째 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseSummaryTableViewCell.identifier) as! CourseSummaryTableViewCell
            
            cell.courseTitleLabel.text = course?.title
            if let start = df.string(for: course?.startDate), let end = df.string(for: course?.endDate) {
                cell.periodLabel.text = "\(start) ~ \(end)"
            }
            cell.timeLabel.text = "매주 화요일, 목요일 17:30~22:30"
            cell.perparationLabel.text = "Xcode9이 설치된 Mac Book"
            cell.locationLabel.text = course?.location
            
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
            // floatingMenu 크기가 40이었음
            // 얘는 두번째 셀
            return 40
        case 2:
            // 두번째 셀
            return 1000
        default:
            return UITableViewAutomaticDimension
        }
    }
}

































