
import UIKit

class DetailViewController: UIViewController {
    
    var course : Course?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var blackBackButton: UIButton!
    @IBOutlet weak var whiteBackButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var center1: NSLayoutConstraint!
    @IBOutlet weak var center2: NSLayoutConstraint!
    @IBOutlet weak var center3: NSLayoutConstraint!
    @IBOutlet weak var moverWidthConstraint: NSLayoutConstraint!
    
    @IBAction func moveToCourse(_ sender: UIButton) {
        center1.isActive = sender.tag == 100
        center2.isActive = sender.tag == 200
        center3.isActive = sender.tag == 300
        
        
        if let title = sender.title(for: .normal), let font = sender.titleLabel?.font {
            let attr = [NSAttributedStringKey.font : font]
            let width = (title as NSString).size(withAttributes: attr).width
            moverWidthConstraint.constant = width
        }
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // flag1
    var whiteMode = false
    // flag2
    var barStyle = UIStatusBarStyle.lightContent
    // what...?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    @IBAction func moveToBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var floatingMenuTopConstraint: NSLayoutConstraint!
    var floatingMenuBase : CGFloat = 0.0
    
    lazy var df : DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M월 d일(E)"
        return f
    } ()
    
    
    
    @IBOutlet weak var firstButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(course)
        
        // 초기상태 구현
        headerBackgroundView.alpha = 0
        blackBackButton.alpha = 0
        whiteBackButton.alpha = 1
        titleLabel.alpha = 0
        titleLabel.text = course?.title
        
        listTableView.contentInset = UIEdgeInsets(top: imageHeightConstraint.constant - headerView.bounds.height, left: 0, bottom: 0, right: 0)
        listTableView.scrollIndicatorInsets = listTableView.contentInset
        
        moveToCourse(firstButton)
    }
    
    
    // 뷰의 서브뷰 레이아웃이 변경된 후 호출됨!!!!!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if floatingMenuBase == 0.0 {
            let ip = IndexPath(row: 1, section: 0)
            if let cell = listTableView.cellForRow(at: ip) {
                let frame = view.convert(cell.frame , to: view)
                floatingMenuBase = frame.origin.y + listTableView.contentInset.top
                floatingMenuTopConstraint.constant = floatingMenuBase
            }
        }
    }
}


extension DetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        let diff = y + 200
        
        floatingMenuTopConstraint.constant = floatingMenuBase - diff
        
        // 이미지 높이변화
        if y < -200 {
            // 스크롤 내릴때
            imageHeightConstraint.constant = 300 + abs(diff)
        } else {
            // 스크롤 올릴때
            imageHeightConstraint.constant = 300
        }
        
        // 헤더 변화
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseSummaryTableViewCell.identifier) as! CourseSummaryTableViewCell
            
            cell.titleLabel.text = course?.title
            if let start = df.string(for: course?.startDate), let end = df.string(for: course?.endDate) {
                cell.periodLabel.text = "\(start) ~ \(end)"
            }
            cell.timeLabel.text = "Every Tue, Wed 19:30~22:30"
            cell.locationLabel.text = course?.location
            cell.preparationLabel.text = "Xcode9 installed MacBook"
            
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
            return 80
        case 2:
            return 1000
        default:
            return UITableViewAutomaticDimension
        }
    }
}































