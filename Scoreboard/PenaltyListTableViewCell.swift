//
//  PenaltyListTableViewCell.swift
//  Scoreboard
//

import UIKit

class PenaltyListTableViewCell: UITableViewCell {
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
