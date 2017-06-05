//
//  ScreenSaverTableViewCell.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/4/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class ScreenSaverTableViewCell: UITableViewCell {

    @IBOutlet weak var screenSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Called when the user toggles the between screen saver on/off
    @IBAction func screenSwitchChange(_ sender: Any) {
        
        //TODO save value to device
    }
}
