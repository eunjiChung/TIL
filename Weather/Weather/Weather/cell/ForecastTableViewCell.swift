
import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var skyImageView: UIImageView!
    
    @IBOutlet weak var skyNameLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        dateLabel.textColor = UIColor.white
        skyNameLabel.textColor = UIColor.white
        tempLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
