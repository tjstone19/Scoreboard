//
//  Constants.swift
//  Scoreboard
//
//

import Foundation
import UIKit

class Constants {
    static let PUSHER_APP_ID: String = "84206"
    static let PUSHER_KEY: String = "420caa3cce45adbb6930"
    static let TTS_PUSHER_KEY: String = "c166e8246043c9cd754b"
    static let PUSHER_SECRET: String = "44724166baa25e29583f"
    
    static let TTS_BASE_API_URL: String = "http://api.sharksice.timetoscore.com"
    static let TTS_API_URL: String = "api.sharksice.timetoscore.com"
    static let TTS_USER_NAME: String = "stone"
    static let TTS_SECRET_KEY: String = "william"
    static let TTS_LEAGUE: String = "league_id=1"
    
    static func getLogo(team: String) ->  UIImage? {
        let lowerTeam = team.lowercased()
        switch lowerTeam {
        case "blue devils":
            return #imageLiteral(resourceName: "blue-devils-logo.jpg")
        case "capital thunder":
            return #imageLiteral(resourceName: "capital-thunder-logo.gif")
        case "cougars":
            return #imageLiteral(resourceName: "cougars-logo.jpg")
        case "monsers":
            return #imageLiteral(resourceName: "fresno-monsters-logo.jpg")
        case "jr sharks":
            return #imageLiteral(resourceName: "jr-sharks-logo.jpg")
        case "bears":
            return #imageLiteral(resourceName: "oakland-bears-logo.jpg")
        case "blackstars":
            return #imageLiteral(resourceName: "redwood-city-blackstars-logo.jpg")
        case "blackhawks":
            return #imageLiteral(resourceName: "santa-clara-blackhaws-logo.gif")
        case "flyers":
            return #imageLiteral(resourceName: "santa-rosa-flyers-logo.jpg")
        case "sabercats":
            return #imageLiteral(resourceName: "sf-sabercats-logo.png")
        case "colts":
            return #imageLiteral(resourceName: "stockton-colts-logo.gif")
        case "grizzlies":
            return #imageLiteral(resourceName: "tahoe-grizzlies-logo.jpg")
        case "jets":
            return #imageLiteral(resourceName: "vacaville-jets-logo.jpg")
        default:
            return nil
        }
    }
}
