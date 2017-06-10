//
//  UserSettings.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/10/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import Foundation


class UserSettings: NSObject, NSCoding {
    // User's preferred club.
    var club: String?
    
    // User's preferred team.
    var team: String?
    
    // Sounds on (true)/ off (false)
    var sounds: Bool = true
    
    // Determines if the screen saver is enabled.
    // enabled = true      disabled = false
    var screenSaver: Bool = true
    
    
    /**
     *  Allow empty constructor so UserSettings can be created without providing values.
     */
    override init() {
        
    }
    
    /**
     * Creates a UserSettings object by retrieving stored data from the devices.
     */
    required init?(coder aDecoder: NSCoder) {
        
        // Preferred club and team will be null if the user has not set them
        club = aDecoder.decodeObject(forKey: "club") as? String
        team = aDecoder.decodeObject(forKey: "team") as? String
        
        // Sounds and screen saver always have a default value
        sounds = aDecoder.decodeBool(forKey: "sounds")
        screenSaver = aDecoder.decodeBool(forKey: "screenSaver")
    }
    
    /**
     * Saves the user's settings to the device's storage.
     */
    func encode(with aCoder: NSCoder) {
        aCoder.encode(club, forKey: "club")
        aCoder.encode(team, forKey: "team")
        aCoder.encode(sounds, forKey: "sounds")
        aCoder.encode(screenSaver, forKey: "screenSaver")
    }
    
    
    /**
     * Saves the user settings to the device.
     */
    func save() {
        // create a data object from self
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        
        // save the data representing this object to the device
        UserDefaults.standard.set(encodedData, forKey: "UserSettings")
    }
    
    /**
     * Loads saved data from storage.
     */
    func load() {
        
        // retrieve data object with key "UserSettings" from storage
        guard let data = UserDefaults.standard.data(forKey: "UserSettings") else {
            print("failed to retrieve data object from storage")
            return
        }
        
        // cast the data object to a UserSettings object
        guard let settings = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserSettings else {
            print("failed to cast data object to UserSettings")
            return
        }
        
        // update the user settings values
        self.club = settings.club
        self.team = settings.team
        self.sounds = settings.sounds
        self.screenSaver = settings.screenSaver
    }
    
}
