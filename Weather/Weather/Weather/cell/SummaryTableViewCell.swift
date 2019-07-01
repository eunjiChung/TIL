
import UIKit

class SummaryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var skyNameLabel: UILabel!
    
    @IBOutlet weak var minMaxLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 셀에 대한 초기화
        backgroundColor = UIColor.clear     //투명하게
        skyNameLabel.textColor = UIColor.white
        minMaxLabel.textColor = UIColor.white
        tempLabel.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
