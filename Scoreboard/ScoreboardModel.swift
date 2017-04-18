//
//  ScoreboardModel.swift
//  Scoreboard
//

import Foundation


struct ScoreboardModel {
    var homeScore: String?
    var homeShots: String?
    var homeP1Number: String?
    var homeP1Time: String?
    var homeP2Number: String?
    var homeP2Time: String?
    
    var awayScore: String?
    var awayShots: String?
    var awayP1Number: String?
    var awayP1Time: String?
    var awayP2Number: String?
    var awayP2Time: String?
    
    var time: String?
    var period: String?
    
    init() {
        homeScore = ""
        homeShots = ""
        homeP1Time = ""
        homeP1Number = ""
        homeP2Time = ""
        homeP2Number = ""
        
        awayScore = ""
        awayShots = ""
        awayP1Time = ""
        awayP1Number = ""
        awayP2Time = ""
        awayP2Number = ""
        
        time = ""
        period = ""
    }
}
