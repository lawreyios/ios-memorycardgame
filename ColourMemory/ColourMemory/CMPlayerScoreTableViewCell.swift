//
//  CMPlayerScoreTableViewCell.swift
//  ColourMemory
//
//  Created by 2359 Lawrence on 16/5/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit

class CMPlayerScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScore: UILabel!    
    @IBOutlet weak var lblRank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
