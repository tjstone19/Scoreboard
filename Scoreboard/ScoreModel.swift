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
    
    init(aPeriod: String, aTime: String, goal: String,
         asst1: String, asst2: String, hmScore: String,
         awyScore: String, winTeam: String) {
        period = aPeriod
        time = aTime
        goalScorer = goal
        assist1 = asst1
        assist2 = asst2
        homeScore = hmScore
        awayScore = awyScore
        winningTeam = winTeam
    }
}
