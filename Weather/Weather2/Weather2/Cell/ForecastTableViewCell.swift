//
//  ForecastTableViewCell.swift
//  Weather2
//
//  Created by CHUNGEUNJI on 2018. 3. 27..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        tempLabel.textColor = UIColor.white
        statusLabel.textColor = tempLabel.textColor
        dateLabel.textColor = tempLabel.textColor
        timeLabel.textColor = tempLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
