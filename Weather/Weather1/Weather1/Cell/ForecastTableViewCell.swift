//
//  ForecastTableViewCell.swift
//  Weather1
//
//  Created by CHUNGEUNJI on 2018. 3. 27..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
        
        dateLabel.textColor = UIColor.white
        timeLabel.textColor = dateLabel.textColor
        statusLabel.textColor = dateLabel.textColor
        temperatureLabel.textColor = dateLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
