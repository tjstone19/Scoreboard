//
//  PenaltyModel.swift
//  Scoreboard
//
//  Created by T.J. Stone on 11/7/16.
//  Copyright © 2016 T.J. Stone. All rights reserved.
//

import Foundation



struct PenaltyModel {
    var period: Int?
    var time: String?
    var type: String?
    var length: String?
    var off: String?
    var player: PlayerModel?
    
    init() {
        period = 1
        time = ""
        type = ""
        length = ""
        off = ""
        player = PlayerModel()
    }
    
    init(aPeriod: Int, aTime: String, aType: String, penLen: String, offIce: String, aPlayer: PlayerModel) {
        period = aPeriod
        time = aTime
        type = aType
        length = penLen
        off = offIce
        player = aPlayer
    }
}
