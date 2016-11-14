//
//  GameTableViewCell.swift
//  Scoreboard
//
//  Created by T.J. Stone on 11/6/16.
//  Copyright © 2016 T.J. Stone. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var rinkLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
