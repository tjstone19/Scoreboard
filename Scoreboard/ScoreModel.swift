//
//  ScoreModel.swift
//  Scoreboard
//
//  Created by T.J. Stone on 11/7/16.
//  Copyright © 2016 T.J. Stone. All rights reserved.
//

import Foundation

struct ScoreModel {
    var period: Int?
    var time: String?
    var goalScorer: PlayerModel?
    var assist1: PlayerModel?
    var assist2: PlayerModel?
    
    init() {
        period = 0
        time = ""
        goalScorer = PlayerModel()
        assist1 = PlayerModel()
        assist2 = PlayerModel()
    }
    
    init(aPeriod: Int, aTime: String, goal: PlayerModel, asst1: PlayerModel, asst2: PlayerModel) {
        period = aPeriod
        time = aTime
        goalScorer = goal
        assist1 = asst1
        assist2 = asst2
    }
}
