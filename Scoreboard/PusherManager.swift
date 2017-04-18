//
//  PusherManager.swift
//  Scoreboard
//
//  Created by T.J. Stone.
//

import Foundation
import PusherSwift
import UserNotifications

class PusherManager {
    var pusher: Pusher!
    
    var myChannel: PusherChannel!
    
    // Contains a list of potential games to view.
    var gamesArray: [GameModel] = [GameModel] ()
    
    // Updated when game events are received.
    var gameData: ScoreboardModel = ScoreboardModel()
    
    // Call back function in the current view controller to call 
    // when data update is received.
    var updateFunction: (() -> Void)?
    
    // Contains goal information for the home score list
    var homeGoals: [ScoreModel] = [ScoreModel]()
    
    // Contains goal information for the away score list
    var awayGoals: [ScoreModel] = [ScoreModel]()
    
    // Contains penalty information for the home penalty list
    var homePenaltys: [PenaltyModel] = [PenaltyModel]()
    
    // Contains penalty information for the away penalty list
    var awayPenaltys: [PenaltyModel] = [PenaltyModel]()
    
    // Contains players for the home team roster
    var homeRoster: [PlayerModel] = [PlayerModel]()
    
    // Contains players for the away team roster
    var awayRoster: [PlayerModel] = [PlayerModel]()
    
    // Maintains data to be displayed on the scoreboard
    var scoreboard: ScoreboardModel = ScoreboardModel()
    
    // Game the user is currently watching
    var currentGame: GameModel = GameModel()
    
    
    func connectToTTS() {
        let encryptor: Encryptor = Encryptor()
        var data: Data
        
        data = encryptor.getDataFromTTS()
    }
    
    // Calls update function in the main thread
    private func callUpdate() {
        DispatchQueue.main.async {
            self.updateFunction!()
        }
    }
    
    // Parses array of game dictionaries
    private func parseGames(_ games: [String : AnyObject]) {
        
        // Loop through the list of game dictionarys
        var model: GameModel = GameModel()
        
        model.gameId = games["game_id"] as? String
        model.rink = games["location"] as? String
        model.homeTeam = games["home_team"] as? String
        model.awayTeam = games["away_team"] as? String
        model.homeScore = games["home_goals"] as? String
        model.awayScore = games["away_goals"] as? String
        
        gamesArray.append(model)
        
        callUpdate()
    }
    
    //{"clock":"02:59","period":"Period 2","homep1":"     ","homep2":"     ","awayp1":"     ","awayp2":"     ","homescore":"  5","awayscore":"  2","homeshots":" 21","awayshots":"  5","hometeam":"Home","awayteam":"Away","game_id":"136076","homep1p":"  ","homep2p":"  ","awayp1p":"  ","awayp2p":"  ","rosters":"0","events":"0","flags":"134217728","info":""}
    // Called when an event is received that contains data
    // to be displayed in the scoreboard view.
    private func scoreBoardUpdate(_ gameData: [String : AnyObject]) {
        scoreboard.time = gameData["clock"] as? String
        scoreboard.period = (gameData["period"] as? String)?
                .replacingOccurrences(of: "Period ", with: "")
        scoreboard.homeScore = (gameData["homescore"] as? String)?
            .replacingOccurrences(of: " ", with: "")
        scoreboard.homeShots = (gameData["homeshots"] as? String)?
            .replacingOccurrences(of: " " , with: "")
        scoreboard.homeP1Number = gameData["homep1p"] as? String
        scoreboard.homeP1Time = gameData["homep1"] as? String
        scoreboard.homeP2Number = gameData["homep2p"] as? String
        scoreboard.homeP2Time = gameData["homep2"] as? String
        scoreboard.awayScore = (gameData["awayscore"] as? String)?
            .replacingOccurrences(of: " ", with: "")
        scoreboard.awayShots = (gameData["awayshots"] as? String)?
            .replacingOccurrences(of: " ", with: "")
        scoreboard.awayP1Number = gameData["awayp1p"] as? String
        scoreboard.awayP1Time = gameData["awayp1"] as? String
        scoreboard.awayP2Number = gameData["awayp2p"] as? String
        scoreboard.awayP2Time = gameData["awayp2"] as? String
        
        updateFunction!()
    }
    
    /*   
     {"event":"my_event","data":{"clock":"13:22","period":"Period
     1","homep1":" ","homep2":" ","awayp1":" ","awayp2":"
     ","homescore":" 1","awayscore":" 0","homeshots":" 1","awayshots":"
     0","hometeam":"Home","awayteam":"Away","game_id":"121250","homep1p":"
     ","homep2p":" ","awayp1p":" ","awayp2p":"
     ","rosters":"0","events":"0","info":"Home Goal:A Dekeyrel,S
     Jameson,M Richardson"},"channel":"north"}
     */
    
    // Called when a goal is scored.
    func parseGoalEvent(data: [String : AnyObject]) {
        var goalData: ScoreModel = ScoreModel()
        var str: String
        var replaceStr : String
        var goalArr: [String]!
        
        
        goalData.period = (data["period"] as? String)?.replacingOccurrences(of: "Period ", with: "")
        goalData.time = data["clock"] as? String
        
        str = (data["info"] as? String)!
        
        if str.contains("Home Goal:") {
            replaceStr = "Home Goal:"
            str = str.replacingOccurrences(of: replaceStr, with: "")
            goalArr = str.characters.split{$0 == ","}.map(String.init)
            
            goalData.goalScorer = goalArr[0]
            
            if goalArr.count > 1 {
                goalData.assist1 = goalArr[1]
            }
            
            if goalArr.count > 2 {
                goalData.assist2 = goalArr[2]
            }
            
            homeGoals.append(goalData)
        }
        else {
            replaceStr = "Away Goal:"
            str = str.replacingOccurrences(of: replaceStr, with: "")
            goalData.goalScorer = str
            
            goalArr = str.characters.split{$0 == ","}.map(String.init)
            
            goalData.goalScorer = goalArr[0]
            
            if goalArr.count > 1 {
                goalData.assist1 = goalArr[1]
            }
            
            if goalArr.count > 2 {
                goalData.assist2 = goalArr[2]
            }
            awayGoals.append(goalData)
        }
        
        updateFunction!()
    }
    
    /*
     {"event":"my_event","data":{"clock":"01:11","period":"Period
     1","homep1":"02:00","homep2":" ","awayp1":" ","awayp2":"
     ","homescore":" 1","awayscore":" 2","homeshots":" 4","awayshots":"
     6","hometeam":"Home","awayteam":"Away","game_id":"121250","homep1p":"24","homep2p":"
     ","awayp1p":" ","awayp2p":" ","rosters":"0","events":"0","info":"Home
     K Richardson: Hooking (2:00)"},"channel":"north"}
     */
    
    // Called when a penalty has been issued to a player.
    private func parsePenaltyEvent(data: [String : AnyObject]) {
        var penaltyData: PenaltyModel = PenaltyModel()
        var info: String = (data["info"] as? String)!
        
    
        penaltyData.period = (data["period"] as! String).replacingOccurrences(of: "Period ", with: "")
        penaltyData.time = data["clock"] as? String
        
        
        
        // Check for home or away penalty
        if info.contains("Home") {
           
            info = info.replacingOccurrences(of: "Home ", with: "")
            var infoArray = info.components(separatedBy: ":")
            
            penaltyData.player = infoArray[0]
            info = info.replacingOccurrences(of: penaltyData.player! + ":", with: "")
            
            info = info.replacingOccurrences(of: "(", with: "")
            info = info.replacingOccurrences(of: ")", with: "")
            infoArray = info.components(separatedBy: " ")
            
            penaltyData.type = infoArray[1]
            penaltyData.length = infoArray[2]
            
            
            homePenaltys.append(penaltyData)
        }
        else {
            info = info.replacingOccurrences(of: "Away ", with: "")
            var infoArray = info.components(separatedBy: ":")
            
            penaltyData.player = infoArray[0]
            info = info.replacingOccurrences(of: penaltyData.player! + ":", with: "")
            
            info = info.replacingOccurrences(of: "(", with: "")
            info = info.replacingOccurrences(of: ")", with: "")
            infoArray = info.components(separatedBy: " ")
            
            penaltyData.type = infoArray[1]
            penaltyData.length = infoArray[2]

            
            awayPenaltys.append(penaltyData)
        }
        
        updateFunction!()
    }
    
    // Adds players to home roster
    private func parseHomeRoster(roster: [[String : AnyObject]]) {
        var player: PlayerModel
        var aPlayer: [String : AnyObject]
        homeRoster = [PlayerModel]()
        
        for temp: [String : AnyObject] in roster {
            aPlayer = temp["map"] as! [String : AnyObject]
            player = PlayerModel()
            player.name = aPlayer["name"] as? String
            player.number = aPlayer["game_jersey"] as? String
            player.goals = aPlayer["goals"] as? String
            player.assists = aPlayer["assists"] as? String
            player.pims = aPlayer["pims"] as? String
            
            homeRoster.append(player)
        }
        
        updateFunction!()
    }
    
    // Adds players to away roster
    private func parseAwayRoster(roster: [[String : AnyObject]]) {
        var player: PlayerModel
        var aPlayer: [String : AnyObject]
        awayRoster = [PlayerModel]()
        
        for temp: [String : AnyObject] in roster {
            aPlayer = temp["map"] as! [String : AnyObject]
            player = PlayerModel()
            player.name = aPlayer["name"] as? String
            player.number = aPlayer["game_jersey"] as? String
            player.goals = aPlayer["goals"] as? String
            player.assists = aPlayer["assists"] as? String
            player.pims = aPlayer["pims"] as? String
            
            awayRoster.append(player)
        }
        
        updateFunction!()
    }
    
    // Establishes pusher connection and binds to event "my-event"
    func establishConnection() {
        
        /*
        let clientOptions: PusherClientOptions = PusherClientOptions(authMethod: .fromObjc(source: .init(secret: Constants.TTS_SECRET_KEY)), attemptToReturnJSONObject: true, autoReconnect: true, host: .host(Constants.TTS_API_URL), port: nil, encrypted: false)
        
        pusher = Pusher(key: Constants.TTS_PUSHER_KEY, options: clientOptions)
        pusher.connect()
        
        var connection: PusherConnection = pusher.connection
        print(connection.url)
        myChannel = pusher.subscribe("north")*/
        
        pusher = Pusher(key: Constants.PUSHER_KEY)
        pusher.connect()
        
        myChannel = pusher.subscribe("my-channel")
       
        // Callback when a pusher notification is received 
        let _ = myChannel.bind(eventName: "my-event",
                               callback: { (data: Any?) -> Void in
            
            if var json = data as? [String : AnyObject] {
                json = json["map"] as! [String : AnyObject]
                // Game Ids data["games"]
                if var message = json["games"] as? [String : AnyObject] {
                    let jsonArray = message["myArrayList"] as! [[String : AnyObject]]
                    for aGame in jsonArray {
                        self.parseGames(aGame["map"] as! [String : AnyObject])
                    }
                    
                }
                // Scoreboard data
                else if ((json["flags"] as? String) != nil) {
                    self.scoreBoardUpdate(json)
                }
                // Roster data
                else if (json["home_players"] != nil)
                    && (json["away_players"] != nil) {
                    var homeMessage = json["home_players"] as? [String : AnyObject]
                    let homeList = homeMessage?["myArrayList"] as? [[String : AnyObject]]
                    var awayMessage = json["away_players"] as? [String : AnyObject]
                    let awayList = awayMessage?["myArrayList"] as? [[String : AnyObject]]
                    
                    
                    //var jsonArray = message?["myArrayList"] as! [[String : AnyObject]]
                    
                    self.parseHomeRoster(roster: homeList!)
                    self.parseAwayRoster(roster: awayList!)
                }
                // Goal or Penalty event
                else if json["event"] as? String == "my_event" {
                    let jsonArray = json["data"] as! [String : AnyObject]
                    print(jsonArray)
                    let message: [String : AnyObject] = jsonArray["map"] as! [String : AnyObject]
                    
                    // Check if event is for a goal
                    if (message["info"] as? String)!.contains("Goal") {
                        self.parseGoalEvent(data: message)
                    }
                    // Event is for penalty if it is not a goal event
                    else {
                        self.parsePenaltyEvent(data: message)
                    }
                }
            }
        })
    }
}
