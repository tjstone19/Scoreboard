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
    
    var periodNumber: Int?
    
    init() {
        period = ""
        time = ""
        type = ""
        length = ""
        player = ""
        periodNumber = 0
    }
}
