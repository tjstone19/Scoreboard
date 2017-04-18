//
//  PlayerModel.swift
//  Scoreboard
//

import Foundation

struct PlayerModel {
    var name: String?
    var number: String?
    var goals: String?
    var assists: String?
    var pims: String?
    
    init() {
        name = ""
        number = ""
    }
    
    init(aName: String, num: String) {
        name = aName
        number = num
    }
}
