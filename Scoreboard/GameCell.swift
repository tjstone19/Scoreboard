//
//  GameCell.swift
//  Scoreboard
//


import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var rinkLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    @IBOutlet weak var homeLogo: UIImageView?
    @IBOutlet weak var awayLogo: UIImageView?
    
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
