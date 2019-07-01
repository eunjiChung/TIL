//
//  MemoTableViewCell.swift
//  MemoApp4
//
//  Created by CHUNGEUNJI on 2018. 3. 24..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
