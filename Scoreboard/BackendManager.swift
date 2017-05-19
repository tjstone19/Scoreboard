//
//  BackendManager.swift
//  Scoreboard
//
//  Created by T.J. Stone on 4/17/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import Foundation

/**
 *  Defines methods and variables required by UI client classes to display data
 *  such as the game score, penalty and score list information, etc.
 */
protocol BackendManager {
    
    //MARK:- Class Variables
    
    // Call back function in the current view controller to call
    // when data update is received.
    var updateFunction: (() -> Void)? {get set}
    
    // Contains a list of potential games to view.
    var gamesArray: [GameModel] {get}
    
    // Game the user is currently watching
    var currentGame: GameModel {get set}

    // Maintains data to be displayed on the scoreboard
    var scoreboard: ScoreboardModel {get}
    
    // Contains goal information for the home score list
    var homeGoals: [ScoreModel] {get}
    
    // Contains goal information for the away score list
    var awayGoals: [ScoreModel] {get}
    
    // Contains penalty information for the home penalty list
    var homePenaltys: [PenaltyModel] {get}
    
    // Contains penalty information for the away penalty list
    var awayPenaltys: [PenaltyModel] {get}
    
    // Contains players for the home team roster
    var homeRoster: [PlayerModel] {get}
    
    // Contains players for the away team roster
    var awayRoster: [PlayerModel] {get}

    
    //MARK:- Class Functions
    
    // Establishes pusher connection and binds to event "my-event"
    func establishConnection()
    
    func bindToGame(gameId: String)
    
    func unbindFromGame()
}
