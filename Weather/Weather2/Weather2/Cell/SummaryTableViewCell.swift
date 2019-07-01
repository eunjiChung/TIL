//
//  SummaryTableViewCell.swift
//  Weather2
//
//  Created by CHUNGEUNJI on 2018. 3. 27..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var minMaxLabel: UILabel!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        statusLabel.textColor = UIColor.white
        minMaxLabel.textColor = statusLabel.textColor
        currentTempLabel.textColor = statusLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
