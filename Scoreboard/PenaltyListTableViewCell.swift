//
//  PenaltyListTableViewCell.swift
//  Scoreboard
//
//  Created by T.J. Stone on 11/7/16.
//  Copyright © 2016 T.J. Stone. All rights reserved.
//

import UIKit

class PenaltyListTableViewCell: UITableViewCell {
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
