//
//  PenaltyModel.swift
//  Scoreboard
//


import Foundation



struct PenaltyModel {
    var period: String?
    var time: String?
    var type: String?
    var length: String?
    var player: String?
    
    init() {
        period = ""
        time = ""
        type = ""
        length = ""
        player = ""
    }
    
    init(aPeriod: String, aTime: String, aType: String, aLength: String, aPlayer: String) {
        period = aPeriod
        time = aTime
        type = aType
        length = aLength
        player = aPlayer
    }
}
