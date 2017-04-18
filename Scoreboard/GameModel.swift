//
//  GameModel.swift
//  Scoreboard
//


import Foundation


struct GameModel {
    var gameId: String?
    var rink: String?
    var homeTeam: String?
    var awayTeam: String?
    var homeScore: String?
    var awayScore: String?
    
    init() {
        gameId = ""
        rink = ""
        homeTeam = ""
        awayTeam = ""
    }
    
    init(id: String, rinkName: String, home: String, away: String) {
        gameId = id
        rink = rinkName
        homeTeam = home
        awayTeam = away
    }
}
