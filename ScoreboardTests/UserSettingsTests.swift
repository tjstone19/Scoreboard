//
//  UserSettingsTests.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/10/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import XCTest
@testable import Scoreboard

class UserSettingsTests: XCTestCase {
    
    var settings: UserSettings?
    
    override func setUp() {
        super.setUp()
        
        settings = UserSettings()
        
        // test values
        settings?.club = "Tri-Valley Blue Devils"
        settings?.team = "Midget 18A"
        settings?.sounds = false
        settings?.screenSaver = false
    }
    
    override func tearDown() {
        super.tearDown()
        settings = nil
    }
    
    
    /**
     *  Tests if the user setting loads when club and team are nil
     */
    func testNilLoad() {
        // save default settings
        settings = UserSettings()
        settings?.save()
        
        // load settings
        let testSettings = UserSettings()
        testSettings.load()
        
        
        // team and club should be nil
        XCTAssertNil(testSettings.club)
        XCTAssertNil(testSettings.team)
        
        // sounds and screen saver are true by default
        XCTAssert(testSettings.sounds == true)
        XCTAssert(testSettings.screenSaver == true)
    }
    
    func testSaveLoad() {
       
        XCTAssert(settings?.club == "Tri-Valley Blue Devils")
        XCTAssert(settings?.team == "Midget 18A")
        XCTAssert(settings?.sounds == false)
        XCTAssert(settings?.screenSaver == false)
        
        // saves the user settings to the device
        settings?.save()
        
        // create a new settings object to see if it can load the saved settings
        // from the device.
        let testSettings: UserSettings = UserSettings()
        testSettings.load()
        
        
        // check if loading settings was successful
        XCTAssert(testSettings.club == "Tri-Valley Blue Devils")
        XCTAssert(testSettings.team == "Midget 18A")
        XCTAssert(testSettings.sounds == false)
        XCTAssert(testSettings.screenSaver == false)
        
    }
    
    
    
}
