//
//  PusherManager.swift
//  Scoreboard
//
//  Created by T.J. Stone.
//

import Foundation
import PusherSwift
import UserNotifications

class PusherManager: BackendManager {
    var pusher: Pusher!
    
    var myChannel: PusherChannel!
    
    var gameChannel: PusherChannel!
    
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
    
    // Ecrypts data from and to the server.
    let encryptor: Encryptor = Encryptor()
    
    
    

    // MARK:- UI Client Update Methods
    
    // Calls update function in the main thread
    private func callUpdate() {
        DispatchQueue.main.async {
            self.updateFunction!()
        }
    }
    
    //{"clock":"02:59","period":"Period 2","homep1":"     ","homep2":"     ","awayp1":"     ","awayp2":"     ","homescore":"  5","awayscore":"  2","homeshots":" 21","awayshots":"  5","hometeam":"Home","awayteam":"Away","game_id":"136076","homep1p":"  ","homep2p":"  ","awayp1p":"  ","awayp2p":"  ","rosters":"0","events":"0","flags":"134217728","info":""}
    // Called when an event is received that contains data
    // to be displayed in the scoreboard view.
    private func scoreBoardUpdate(_ gameData: [String : AnyObject]) {
        scoreboard.time = gameData["clock"] as? String
        scoreboard.period = (gameData["period"] as? String)?
                .replacingOccurrences(of: "Period ", with: "")
        scoreboard.homeScore = (gameData["home_goals"] as? String)?
            .replacingOccurrences(of: " ", with: "")
        scoreboard.homeShots = (gameData["home_shots"] as? String)?
            .replacingOccurrences(of: " " , with: "")
        scoreboard.homeP1Number = gameData["homep1p"] as? String
        scoreboard.homeP1Time = gameData["homep1"] as? String
        scoreboard.homeP2Number = gameData["homep2p"] as? String
        scoreboard.homeP2Time = gameData["homep2"] as? String
        scoreboard.awayScore = (gameData["away_goals"] as? String)?
            .replacingOccurrences(of: " ", with: "")
        scoreboard.awayShots = (gameData["away_shots"] as? String)?
            .replacingOccurrences(of: " ", with: "")
        scoreboard.awayP1Number = gameData["awayp1p"] as? String
        scoreboard.awayP1Time = gameData["awayp1"] as? String
        scoreboard.awayP2Number = gameData["awayp2p"] as? String
        scoreboard.awayP2Time = gameData["awayp2"] as? String
        
        updateFunction!()
    }
    
    
    //MARK:- Parse Data Methods
    
    // Parses array of game dictionaries
    private func parseGames(_ games: [[String : AnyObject]]) {
        
        // Loop through the list of game dictionarys
        for aGame: [String : AnyObject] in games {
            var model: GameModel = GameModel()
            
            // get game fields from game dictionary
            model.gameId = aGame["game_id"] as? String
            model.rink = aGame["location"] as? String
            model.homeTeam = aGame["home_team"] as? String
            model.awayTeam = aGame["away_team"] as? String
            model.homeScore = aGame["home_goals"] as? String ?? ""
            model.awayScore = aGame["away_goals"] as? String ?? ""
            model.time = aGame["time"] as? String
            model.date = aGame["date"] as? String
            
            // get game date
            if model.isUpcomingGame() {
                //getScoreUpdateForGame(gameId: model.gameId!)
                gamesArray.append(model)
            }
            
        }
        
        // sort the games in ascending order by date and time
        sortGames()
        
        // update UI
        callUpdate()
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
        
        goalData.periodNumber = data["period"] as? Int
        goalData.period = goalData.periodNumber == nil ? "X" : "\(goalData.periodNumber!)"
        goalData.time = data["time_in_period"] as? String
        
        str = (data["text"] as? String)!
        
        // check if description text contains the home team's name
        if str.contains(self.currentGame.homeTeam!) {
            
            // remove the team's name and "Goal" from the text description
            replaceStr = "\(self.currentGame.homeTeam!) Goal "
            
            str = str.replacingOccurrences(of: replaceStr, with: "")
            
            // replace the parens '(' & ')' surrounding the names of the goal participants
            str = str.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            goalArr = str.characters.split{$0 == ","}.map(String.init)
           
            if goalArr.count == 0 {
                goalData.goalScorer = "N/A"
                 homeGoals.append(goalData)
                return
            }
            
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
            replaceStr = "\(self.currentGame.awayTeam!) Goal "
            
            // bad goal update
            if replaceStr.contains("Please Hold") {
                return
            }
            str = str.replacingOccurrences(of: replaceStr, with: "")
            
            // replace the parens '(' & ')' surrounding the names of the goal participants
            str = str.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            
            
            goalArr = str.characters.split{$0 == ","}.map(String.init)
            
            
            if goalArr.count == 0 {
                goalData.goalScorer = "N/A"
                awayGoals.append(goalData)
                return
            }
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
    
    private func parseMinutes(mins: String) -> String {
        // Determines the length of the penalty
        switch mins {
            case "1200":
                return "2:00"
            case "1800":
                return "2:00"
            case "2400":
                return "4:00"
        default:
                return mins
        }
    }
    
    // Called when a penalty has been issued to a player.
    private func parsePenaltyEvent(data: [String : AnyObject]) {
        var penaltyData: PenaltyModel = PenaltyModel()
        var info: String = (data["text"] as? String)!
        
        penaltyData.periodNumber = data["period"] as? Int
        
        penaltyData.period = "\(penaltyData.periodNumber!)"
        penaltyData.time = data["time_in_period"] as? String
        
        
        
        // Check for home or away penalty
        var replaceStr = "\(self.currentGame.homeTeam!) Penalty "
        
        if info.contains("\(self.currentGame.homeTeam!)") {
            
            replaceStr = "\(self.currentGame.homeTeam!) Penalty "
            
            // remove team name and penalty from info string
            info = info.replacingOccurrences(of: replaceStr, with: "")
            
            // seperate player name from penalty description
            var infoArray = info.components(separatedBy: "(")
            
            // player name is the first item
            penaltyData.player = infoArray[0]
            
            // grab penalty description from the second item
            info = infoArray[1].replacingOccurrences(of: ")", with: "")
            
            // remove semi colons
            infoArray = info.components(separatedBy: ";")
            
            // combine penalty severity (minor/major) with type (hooking)
            penaltyData.type = infoArray[2] + " " + infoArray[0].replacingOccurrences(of: "&nbsp", with: "")
            
            
            penaltyData.length = parseMinutes(mins: data["minutes"] as! String)
            
            
            homePenaltys.append(penaltyData)
        }
        else {
            //Beekeepers 2  Penalty Allan Scott (Hooking&nbsp;-&nbsp;Minor)
            replaceStr = "\(self.currentGame.awayTeam!) Penalty "
            
            // remove team name and penalty from info string
            info = info.replacingOccurrences(of: replaceStr, with: "")
            
            // seperate player name from penalty description
            // i.e. Allan Scott (Hooking&nbsp;-&nbsp;Minor)
            var infoArray = info.components(separatedBy: "(")
            
            // player name is the first item
            // i.e Allan Scott
            penaltyData.player = infoArray[0]
            
            // grab penalty description from the second item
            // i.e. Hooking&nbsp;-&nbsp;Minor)
            info = infoArray[1].replacingOccurrences(of: ")", with: "")
            
            // 0: Hooking&nbsp 1: -&nbsp 2: Minor
            infoArray = info.components(separatedBy: ";")
            
            
            // combine penalty severity (minor/major) with type (hooking)
            penaltyData.type = infoArray[2] + " " + infoArray[0].replacingOccurrences(of: "&nbsp", with: "")
            
            penaltyData.length = parseMinutes(mins: data["minutes"] as! String)

            
            awayPenaltys.append(penaltyData)
        }
        
        updateFunction!()
    }
    
    // Adds players to home roster
    private func parseHomeRoster(roster: [[String : AnyObject]]) {
        var player: PlayerModel
        
        homeRoster = [PlayerModel]()
        
        for temp: [String : AnyObject] in roster {
            
            player = PlayerModel()
            player.name = temp["name"] as? String
            player.number = temp["game_jersey"] as? String
            
            if player.number == "00" {
                player.number = "0"
            }
            
            player.goals = temp["goals"] as? String
            player.assists = temp["assists"] as? String
            player.pims = temp["pims"] as? String
            
            homeRoster.append(player)
        }
        
        updateFunction!()
    }
    
    // Adds players to away roster
    private func parseAwayRoster(roster: [[String : AnyObject]]) {
        var player: PlayerModel
        
        awayRoster = [PlayerModel]()
        
        for temp: [String : AnyObject] in roster {
            player = PlayerModel()
            player.name = temp["name"] as? String
            player.number = temp["game_jersey"] as? String
            
            if player.number == "00" {
                player.number = "0"
            }

            player.goals = temp["goals"] as? String
            player.assists = temp["assists"] as? String
            player.pims = temp["pims"] as? String
            
            awayRoster.append(player)
        }
        
        updateFunction!()
    }
    
    //MARK:- HTTP Calls
    
    /**
     *  Downloads today's games from TTS
     */
    private func connectToTTS() {
    
        // Gets the list of games from Time To Score
        encryptor.getGameDataFromTTS(completion: { data in
            
            // Make sure game data was successfully retrieved
            guard let gameData = data else {return}
            
            // Check for array of game dictionaries
            if gameData["games"] != nil {
                self.parseGames(gameData["games"] as! [[String : AnyObject]])
            }
        })
    }
    
    //
    //  Downloads the score board update for the given game via http request.
    //
    func getScoreUpdateForGame(gameId: String) {
        
        
        // TEAM INFO
        self.encryptor.getDataFor(gameId: gameId,
                                  type: .teamInfo,
                                  completion: { data in
                                    print(data ?? "no team info data")
                                    
            // update the score for the given game
            let gameIdx = self.gamesArray.index(where: {return $0.gameId! == gameId})!
            
            // update the home and away score
            let homeScore: Int? = data?["home_goals"] as? Int
            let homeScoreStr: String? = homeScore == nil ? "" : "\(homeScore!)"
            let awayScore: Int? = data?["away_goals"] as? Int
            let awayScoreStr: String? = awayScore == nil ? "" : "\(awayScore!)"
            
            self.gamesArray[gameIdx].homeScore = homeScoreStr ?? ""
            self.gamesArray[gameIdx].awayScore = awayScoreStr ?? ""
                                    
            
            self.callUpdate()
        })
    }
    
    //
    // Downloads data for the given game id
    //    - roster data
    //    - team data
    //    - game events
    func getGameInfo(gameId: String) {
        
        // ROSTER
        self.encryptor.getRosterData(gameId: gameId,
                                     completion: { data in
                                        
            // validate roster data
            if ((data?["home_players"] as? [[String : AnyObject]]) != nil)
                && ((data?["away_players"] as? [[String : AnyObject]]) != nil) {
                self.parseHomeRoster(roster: data?["home_players"] as! [[String : AnyObject]])
                self.parseAwayRoster(roster: data?["away_players"] as! [[String : AnyObject]])
            }
        })
        
        
        // GAME EVENTS
        self.encryptor.getDataFor(gameId: gameId, type: .gameEvents,
                                  completion: { data in
                                    
            // check for events dictionary in the data from TTS
            guard let eventDict = data?["events"] as? [[String : AnyObject]] else {return}
            
            // parse the list of game events
            self.parseEvents(events: eventDict)
        })
        
        
        // TEAM INFO
        self.encryptor.getDataFor(gameId: gameId,
                                  type: .teamInfo,
                                  completion: { data in
            self.scoreBoardUpdate(data!)
        })
    }
    
    
    /**
     *  Parses HTTP game events from TTS
     */
    func parseEvents(events: [[String : AnyObject]]) {
        for event in events {
            if event["type"] as? String != nil {
                switch event["type"] as! String {
                case "Goal":
                    self.parseGoalEvent(data: event)
                    break
                case "Penalty":
                    print(event)
                    self.parsePenaltyEvent(data: event)
                    break
                default:
                    print("PusherManager (parseEvents()): Unrecognized Game Event")
                }
            }
        }
    }
    
    // Mark:- Pusher Methods
    
    /**
     *  Subscribes to a game's pusher channel.  Receives game updates from the channel
     *  and calls appropriate methods to parse the data and update UI client classes
     *  that need to display the data.
     */
    private func setUpPusherChannel() {
        myChannel = pusher.subscribe("north")
        
        // Callback when a pusher notification is received
        let _ = myChannel.bind(eventName: "my_event",
                               callback: { (data: Any?) -> Void in
                                
            if let data = data as? [String : AnyObject] {
                // Game Ids
                if let message = data["games"] as? [[String : AnyObject]] {
                    self.parseGames(message)
                }
                    // Scoreboard data
                else if ((data["flags"] as? String) != nil) {
                    self.scoreBoardUpdate(data)
                }
                    // Roster data
                else if ((data["home_players"] as? [[String : AnyObject]]) != nil)
                    && ((data["away_players"] as? [[String : AnyObject]]) != nil) {
                    self.parseHomeRoster(roster: data["home_players"] as! [[String : AnyObject]])
                    self.parseAwayRoster(roster: data["away_players"] as! [[String : AnyObject]])
                }
                    // Goal or Penalty event
                else if data["event"] as? String == "my_event" {
                    let message: [String : AnyObject] = data["data"] as! [String : AnyObject]
                    
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
            else {
                print("ERROR CONVERTING PUSHER DATA TO A DICTIONARY:\n")
                print(data ?? "Data is nil")
            }
        })
    }
    
    
    /**
     *  Unbinds the game channel from all events and sets the channel to nil
     */
    func unbindFromGame() {
        if gameChannel != nil {
            gameChannel.unbindAll()
        }
        
        self.clearGameLists()
    }
    
    //
    // Creates a pusher channel subscribing to the given rink.
    //
    func bindToGame(gameId: String) {
        
        // get the index of the game with the given id
        // exit if no game was found
        guard let gameIdx: Int = gamesArray.index(where: {$0.gameId == gameId}) else {return}
        
        
        // SET THE CURRENT GAME
        currentGame = gamesArray[gameIdx]
        
        // get the game rink removing san jose and spaces, converted to lower case
        let rink = currentGame.rink?
            .replacingOccurrences(of: "San Jose", with: "")
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
        
        // HTTP calls to download roster, score list, 
        // and penalty list data for the selected game
        self.getGameInfo(gameId: gameId)
        
        
    }

    // Establishes pusher connection and binds to event "my-event"
    func establishConnection() {
        // create options for pusher client connection
        /*let clientOptions: PusherClientOptions =
            PusherClientOptions(authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: Authorizer()),
                                attemptToReturnJSONObject: true,
                                autoReconnect: true,
                                host: .host(Constants.TTS_PUSHER_HOST),
                                port: 8080,
                                encrypted: false)
       let clientOptions: PusherClientOptions =
            PusherClientOptions(authMethod: .inline(secret: Constants.TTS_SECRET_KEY),
                                attemptToReturnJSONObject: true,
                                autoReconnect: true,
                                host: .host(Constants.TTS_PUSHER_HOST),
                                port: 8080,
                                encrypted: false)
        
        // create pusher object with our options for the given game
        pusher = Pusher(withAppKey: Constants.TTS_PUSHER_KEY, options: clientOptions)*/
        pusher = Pusher(key: Constants.TTS_PUSHER_KEY)
        
        
        
        // use this class as the pusher delegate
        pusher.delegate = self
        pusher.connection.delegate = self
        
        
        
        
        // subscribe to the pusher channel for the given rink
        //gameChannel = gamePusher.subscribe(rink!)
        gameChannel = pusher.subscribe("south")
        
        
        // bind to events for the given game ID
        
        gameChannel.bind(eventName: "my_event", callback: { (data: Any?) -> Void in
            print("\nGAME CHANNEL DATA")
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                }
            }
            
        })
        
        
        
        pusher.bind({ (data: Any?) -> Void in
            
            if let data = data as? [String : AnyObject] {
                print(data)
            }
        })
        
       
        // establish connection
        pusher.connect()
        
        // Connect to pusher channel that broadcasts game events.
       // setUpPusherChannel()
      
        
        // TODO: UNCOMMENT WHEN TRYING TO CONNECT TO TIME TO SCORE
        connectToTTS()
    }
    
    
    
    // Mark:- Game List Book Keeping Methods
    
    /**
     *  Sorts games in descending order of their date and time.
     */
    private func sortGames() {
        
        // sort the games in ascending order: 1) Date 2) Hour/Minute
        gamesArray.sort(by: {$0.0.gameDate! < $0.1.gameDate!})
    }
    
    /**
     *  Sets the arrays for goals, penaltys, and rosters to empty arrays.
     *  Called when PusherManager unbinds from a game.
     */
    private func clearGameLists() {
        self.homeGoals = []
        self.awayGoals = []
        self.homeRoster = []
        self.awayRoster = []
        self.homePenaltys = []
        self.awayPenaltys = []
    }

}

// Mark:- PusherDelegate Methods
extension PusherManager: PusherDelegate {
    func registeredForPushNotifications(clientId: String) {
        print("\n\n Pusher Delegate: didRegisterForPushNotifications: clientId = " + clientId)
    }
    func subscribedToInterest(name: String) {
        print("\n\n Pusher Delegate: didSubscribeToInterest: " + name)
    }
    func unsubscribedFromInterest(name: String) {
        print("\n\n Pusher Delegate: didUnsubscribeFromInterest: " + name)
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("\nPUSHER CONNECTION CHANGE STATE: \(old.stringValue()) to \(new.stringValue())\n")
    }
    func subscribedToChannel(name: String) {
        print("\nPUSHER CONNECTION SUBSCRIBED TO: \(name)\n")
        
        var data: Data?
        
        do {
            try data = JSONSerialization.data(withJSONObject: ["data" : "south"], options: .prettyPrinted)
            
        }
        catch {
            print("JSON FAIL")
        }
       
        print(data!)
        
        
        gameChannel.trigger(eventName: "my_event", data: data!)
    }
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("PUSHER CONNECTION FAILED TO SUBSCRIBE: name = \n" + name + "\nresponse = \(String(describing: response))" + "\ndata= \(String(describing: data))" + "\nerror = \(String(describing: error))")
    }
    func debugLog(message: String) {
        print("\nPUSHER CONNECTION DEBUG: \(message)\n")
    }
}



