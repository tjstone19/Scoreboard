//
//  ScoreListTableViewCell.swift
//  Scoreboard


import UIKit

class ScoreListTableViewCell: UITableViewCell {

    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goalScorerLabel: UILabel!
    @IBOutlet weak var assist1Label: UILabel!
    @IBOutlet weak var assist2Label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
