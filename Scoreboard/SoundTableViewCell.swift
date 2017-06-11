//
//  SoundTableViewCell.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/4/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class SoundTableViewCell: UITableViewCell {

    @IBOutlet weak var soundSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // Called when the user toggles sounds on and off.
    @IBAction func switchChanged(_ sender: Any) {
        // create settings object and load saved settings
        let settings: UserSettings = UserSettings()
        settings.load()
        
        // update sounds setting
        settings.sounds = soundSwitch.isOn
        
        // save the new settings to the device
        settings.save()

    }
}
