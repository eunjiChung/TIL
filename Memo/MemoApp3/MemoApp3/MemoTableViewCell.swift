//
//  MemoTableViewCell.swift
//  MemoApp3
//
//  Created by CHUNGEUNJI on 2018. 3. 23..
//  Copyright © 2018년 CHUNGEUNJI. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var memoTitleLabel: UILabel!
    
    @IBOutlet weak var memoContentLabel: UILabel!
    
    @IBOutlet weak var memoDateLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
