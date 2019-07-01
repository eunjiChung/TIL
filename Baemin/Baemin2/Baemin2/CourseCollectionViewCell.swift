
import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    static let identifier = "CourseCollectionViewCell"
    
    @IBOutlet weak var courseImageView: UIImageView!
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    
    @IBOutlet weak var coursePeriodLabel: UILabel!
    
    @IBOutlet weak var courseTagLabel: UILabel!
    
    @IBOutlet weak var courseLocationLabel: UILabel!
    
}
