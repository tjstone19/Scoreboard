//
//  ScoreboardTests.swift
//  ScoreboardTests
//


import XCTest
@testable import Scoreboard

class ScoreboardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGoalJSON() {
        let pm: PusherManager = PusherManager()
        let test: [String: String] = ["clock": "13:22","period":"Period 1","homep1":" ","homep2": " ","awayp1":" ","awayp2":"","homescore":" 1","awayscore":" 0","homeshots":" 1","awayshots":"0","hometeam":"Home","awayteam":"Away","game_id":"121250","homep1p":"","homep2p":"","awayp1p":"","awayp2p":"","rosters":"0","events":"0","info":"Home Goal:A Dekeyrel,SJameson,M Richardson"]
        
        pm.parseGoalEvent(data: test as [String : AnyObject])
        
        XCTAssert(pm.homeGoals.count == 1)
        XCTAssert(pm.homeGoals[0].time == "13:22")
    }
    
}
