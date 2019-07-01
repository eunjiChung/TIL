
import UIKit



struct Course {
    let title: String
    let imageName: String
    let startDate: Date
    let endDate: Date
    let tags: [String]
    let location: String
}


class ViewController: UIViewController {
    
    var courseList = [
        Course(title: "Swift4를 활용한 iOS 앱 개발 CAMP", imageName: "course0", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "나만의 iOS 앱 개발 입문 CAMP", imageName: "course1", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "Unity 5 게임 제작 CAMP", imageName: "course2", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "JavaScript 정복 프로젝트 CAMP", imageName: "course3", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A"),
        Course(title: "Node.js로 구현하는 쇼핑몰 프로젝트 CAMP", imageName: "course4", startDate: Date(), endDate: Date(), tags: ["iOS", "Swift4"], location: "리틀스타 10-A")
    ]
    
    @IBOutlet weak var moverWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var center1: NSLayoutConstraint!
    @IBOutlet weak var center2: NSLayoutConstraint!
    @IBOutlet weak var center3: NSLayoutConstraint!
    @IBOutlet weak var center4: NSLayoutConstraint!
    @IBOutlet weak var center5: NSLayoutConstraint!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var courseCollectionView: UICollectionView!
    
    @IBOutlet weak var courseCollection: UICollectionView!
    
    
    
    var timer: DispatchSourceTimer?
    
    lazy var df: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M월 d일(E)"
        return f
    }()
    
    
    
    @IBAction func selectMenu(_ sender: UIButton) {
        center1.isActive = sender.tag == 100
        center2.isActive = sender.tag == 200
        center3.isActive = sender.tag == 300
        center4.isActive = sender.tag == 400
        center5.isActive = sender.tag == 500
        
        if let title = sender.title(for: .normal), let font = sender.titleLabel?.font {
            let attr = [NSAttributedStringKey.font: font]
            let width = (title as NSString).size(withAttributes: attr).width
            moverWidthConstraint.constant = width
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        
        
        for _ in 0...10 {
            // 랜덤함수는 보통 이걸 사용
            let a = arc4random_uniform(UInt32(courseList.count))
            let b = arc4random_uniform(UInt32(courseList.count))
            // 카드섞는것처럼 섞는 함수
            courseList.swapAt(Int(a), Int(b))
        }
        
        courseCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectMenu(firstButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let targetIndexPath = IndexPath(item: 5000, section: 0)
        bannerCollectionView.selectItem(at: targetIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        resumeTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.suspend()
    }

    func resumeTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer?.schedule(deadline: .now() + 5, repeating: .seconds(5))
            timer?.setEventHandler(handler: {
                if var currentIndexPath = self.bannerCollectionView.indexPathsForVisibleItems.first {
                    currentIndexPath.item += 1
                    self.bannerCollectionView.selectItem(at: currentIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
            })
        }
        
        timer?.resume()
    }

}



extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            return 10000
        case courseCollectionView:
            return courseList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
        case bannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
            
            let imageName = "banner\(indexPath.item % 5)"
            cell.bannerImageView.image = UIImage(named: imageName)
            
            return cell
        case courseCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
            
            let course = courseList[indexPath.item]
            cell.courseImageView.image = UIImage(named: course.imageName)
            cell.courseNameLabel.text = course.title
            
            if let start = df.string(for: course.startDate), let end = df.string(for: course.endDate) {
                cell.periodLabel.text = "\(start) ~ \(end)"
            }
            
            cell.tagLabel.text = "#" + course.tags.joined(separator: " #")
            cell.locationLabel.text = course.location
            
            return cell
        default:
            fatalError()
        }
        
        
        
        
       
    }
    
    
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case bannerCollectionView:
            return collectionView.frame.size
        case courseCollectionView:
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
                return CGSize.zero
            }
            
            let width = (collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing)) / 2
            return CGSize(width: width, height: width * 1.5)
        default:
            return CGSize.zero
        }
    }
}


























































