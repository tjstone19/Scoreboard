//
//  ScoreModel.swift
//  Scoreboard
//

import Foundation

struct ScoreModel {
    var period: String?
    var time: String?
    var goalScorer: String?
    var assist1: String?
    var assist2: String?
    var homeScore: String?
    var awayScore: String?
    var winningTeam: String?
    
    var periodNumber: Int?
    
    init() {
        period = ""
        time = ""
        goalScorer = ""
        assist1 = ""
        assist2 = ""
        homeScore = ""
        awayScore = ""
        winningTeam = ""
    }
    
    
}
