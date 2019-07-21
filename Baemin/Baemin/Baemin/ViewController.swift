
import UIKit

// 일반적으로는 새로운 스위프트 파일에 넣는게 맞음. 수업때만 잠시...
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
    
    @IBOutlet weak var Center1: NSLayoutConstraint!
    
    @IBOutlet weak var Center2: NSLayoutConstraint!
    
    @IBOutlet weak var Center3: NSLayoutConstraint!
    
    @IBOutlet weak var Center4: NSLayoutConstraint!
    
    @IBOutlet weak var Center5: NSLayoutConstraint!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var courseCollectionView: UICollectionView!
    
    // 지연 저장 속성. 초깃값은 클로저. 접근할때 메모리 할당
    lazy var df: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "M월 d일(E)"
        return f
    }()
    
    
    
    // 다섯개의 버튼을 여기서 다 처리.
    // 버튼 누를때 sender로 버튼이 전달됨 -> 각 버튼은 tag로 구분
    // 밑에 바가 이동하는건 각 centerX를 조절
    @IBAction func selectMenu(_ sender: UIButton) {
        // if문 쓰면 복잡해짐. Center 활성화.
        Center1.isActive = sender.tag == 100
        Center2.isActive = sender.tag == 200
        Center3.isActive = sender.tag == 300
        Center4.isActive = sender.tag == 400
        Center5.isActive = sender.tag == 500
        
        // 폰트는 항상 있으니 titleLabel의 ?를 !로 바꿔줌
        let dict = [NSAttributedStringKey.font: sender.titleLabel!.font!]
        
        // 받아올 너비 기본 선언
        var targetWidth: CGFloat = 100
        if let text = sender.title(for: .normal) {
            targetWidth = (text as NSString).size(withAttributes: dict).width
        }
        
        width.constant = targetWidth
        
        // 1. 기본 애니메이션 효과가 들어감
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
        
        // 2. Spring효과주는 애니메이션
        // damping이랑 Velocity를 바꾸면 효과가 조금 바뀜
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        for _ in 0 ..< 10 {
            let a = Int(arc4random_uniform(UInt32(courseList.count)))
            let b = Int(arc4random_uniform(UInt32(courseList.count)))
            courseList.swapAt(a, b)
        }
        
        let section = IndexSet(integer: 0)
        courseCollectionView.reloadSections(section)
    }
    
    
    // 이게 뭐지
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("detailSegue"):
            if let vc = segue.destination as? DetailViewController, let cell = sender as? UICollectionViewCell, let indexPath = courseCollectionView.indexPath(for: cell) {
                vc.course = courseList[indexPath.item]
            }
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        selectMenu(firstButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TableView와 차이점 -> item, section 둘이 합쳐서 indexPath
        let targetIndexPath = IndexPath(item: 5000, section: 0)
        bannerCollectionView.selectItem(at: targetIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        resumeTimer() // 직접 멈춰주지 않으면 계속 돌아감 -> 그래서 화면 벗어나기 전에 멈춰줘야함 -> viewWillDisappaer에서 멈춤
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 멈춰줌
        timer?.suspend()
    }
    
    
    // 배너 스크롤이 자동으로 넘어가도록 타이머 생성
    var timer: DispatchSourceTimer?
    // 배너 스크롤과 관련된 새로운 타이머 => 얘는 그대로 외우면 됨
    func resumeTimer() {
        if timer == nil {
            // 타이머가 만들어지는 코드. 메인 스레드에서 만들어짐.
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            // 타이머의 시작시점과 반복시점을 만든다
            // Deadline : 지금으로부터 5초 뒤에 시작
            // repeating : 5초마다 반복
            timer?.schedule(deadline: .now() + 5, repeating: 5.0)
            // 5초마다 클로저에 포함된 코드가 실행됨
            timer?.setEventHandler(handler: {
//                print("===============")
                // 배너 지정해서 회전시켜줌
                if var currentIndexPath = self.bannerCollectionView.indexPathsForVisibleItems.first {
                    currentIndexPath.item += 1
                    // 애니메이션 효과 적용
                    self.bannerCollectionView.selectItem(at: currentIndexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
            })
        }
        
        // 타이머를 시작시켜줌
        timer?.resume()
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // CollectionView가 두개라서 구분해서 분기해야됨
        // 얘는 BannerCollectionView
        if collectionView == bannerCollectionView {
            return 10000
        }
        
        // 얘는 CourseCollectionView
        return courseList.count
    }
    
    // CollectionView가 두개라서 충돌이 일어날 수 있음
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 이것도 분기문
        if collectionView == bannerCollectionView {
            // type casting
            // 이렇게 하면 오류를 빨리 찾을 수 있음
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCollectionViewCell
            
            // 모듈러 연산을 통해 무한히 배너가 나오도록
            let imgName = "banner\(indexPath.item % 5)"
            
            cell.bannerImageView.image = UIImage(named: imgName)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath  ) as! CourseCollectionViewCell
        
        // 셀의 데이터를 가져온다
        let target = courseList[indexPath.item]
        cell.courseImageView.image = UIImage(named: target.imageName)
        cell.titleLabel.text = target.title
        
        // Optional Binding if와 guard문의 구분 가능!!
        if let start = df.string(for: target.startDate), let end = df.string(for: target.endDate) {
            cell.dateLabel.text = "\(start) ~ \(end)"
        }
        
        let tagString = "#" + target.tags.joined(separator: " #")
        cell.tagLabel.text = tagString
        
        cell.locationLabel.text = target.location
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return collectionView.frame.size
        }
        
        // CourseCollectionView에 두 개 들어가기 위한 너비 계산
        let width = (collectionView.bounds.width - 30) / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}


















