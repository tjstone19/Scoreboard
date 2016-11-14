//
//  ScoreListTableViewCell.swift
//  Scoreboard
//
//  Created by T.J. Stone on 11/7/16.
//  Copyright © 2016 T.J. Stone. All rights reserved.
//

import UIKit

class ScoreListTableViewCell: UITableViewCell {

    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goalScorerLabel: UILabel!
    @IBOutlet weak var assistLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
