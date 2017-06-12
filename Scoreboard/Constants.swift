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
    static let TTS_PUSHER_HOST: String = "pusher.timetoscore.com"
    static let TTS_USER_NAME: String = "stone"
    static let TTS_SECRET_KEY: String = "william"
    static let TTS_LEAGUE: String = "league_id=1"
    
    static let UPCOMING_GAME_RANGE: Int = 5
    
    // Locale for formatting date objects.
    static let EN_US_POSIX = Locale(identifier: "en_US_POSIX")
    
    // Timezone for formatting date objects.
    static let TIMEZONE = TimeZone(secondsFromGMT: 0)

    
    
    // Background image for views.
    static let BACKGROUND_IMAGE = #imageLiteral(resourceName: "background-ice1")
    static let BACKGROUND_IMAGE_OPACITY: CGFloat = 0.4
    
    // Background opacity for view controllers and table views
    static let BACKGROUND_OPACITY: CGFloat = 0.5
    
    // Background opacity for pop up views
    static let POP_UP_OPACITY: CGFloat = 0.8
    
    // Clubs in the league.
    static let CLUBS = ["California Cougars","Capital Thunder","Golden State Elite Eagles","Fresno Jr. Monsters","Oakland Bears", "Redwood City Black Stars", "San Francisco Sabercats", "San Jose Jr. Sharks", "Santa Clara Blackhawks", "Santa Rosa Flyers","Stockton Colts","Tahoe Grizzlies","Tri-Valley Blue Devils", "Vacaville Jets"]
    
    // Team divisions in the league.
    static let TEAMS = ["Mite X", "Squirt A", "Squirt B", "Squirt BB", "Pee Wee A", "Pee Wee B", "Pee Wee BB", "Bantam A", "Bantam B", "High School D2", "High School D3", "Girls 10-U", "Girls 12-U", "Girls 14-U", "Girls 16-U", "Girls 19-U"]
    
    
    
    /**
     *  Returns the image for the given team's logo.
     */
    static func getLogo(team: String) ->  UIImage? {
        let lowerTeam = team.lowercased()
        
        // determine the team name and return their logo
        switch lowerTeam {
            
            case "blue devils", "tri-valley blue devils":
                return #imageLiteral(resourceName: "blue-devils-logo.jpg")
                
            case "capital thunder":
                return #imageLiteral(resourceName: "capital-thunder-logo.gif")
                
            case "cougars", "california cougars":
                return #imageLiteral(resourceName: "cougars-logo.jpg")
                
            case "monsers", "fresno jr. monsters":
                return #imageLiteral(resourceName: "fresno-monsters-logo.jpg")
                
            case "jr sharks", "san jose jr. sharks":
                return #imageLiteral(resourceName: "jr-sharks-logo.jpg")
                
            case "bears", "oakland bears":
                return #imageLiteral(resourceName: "oakland-bears-logo.jpg")
                
            case "blackstars", "redwood city black stars":
                return #imageLiteral(resourceName: "redwood-city-blackstars-logo.jpg")
                
            case "blackhawks", "santa clara blackhawks":
                return #imageLiteral(resourceName: "santa-clara-blackhaws-logo.gif")
                
            case "flyers", "santa rosa flyers":
                return #imageLiteral(resourceName: "santa-rosa-flyers-logo.jpg")
                
            case "sabercats", "san francisco sabercats":
                return #imageLiteral(resourceName: "sf-sabercats-logo.png")
                
            case "colts", "stockton colts":
                return #imageLiteral(resourceName: "stockton-colts-logo.gif")
                
            case "grizzlies", "tahoe grizzlies":
                return #imageLiteral(resourceName: "tahoe-grizzlies-logo.jpg")
                
            case "jets", "vacaville jets":
                return #imageLiteral(resourceName: "vacaville-jets-logo.jpg")
                
        default:
            return nil
        }
    }
}
