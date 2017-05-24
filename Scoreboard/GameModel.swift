//
//  GameModel.swift
//  Scoreboard
//


import Foundation


struct GameModel {
    var gameId: String?
    var rink: String?
    var homeTeam: String?
    var awayTeam: String?
    var homeScore: String?
    var awayScore: String?
    var time: String?
    var date: String?
    
    // Date object created by adding the GameModel's date and time strings together.
    var gameDate: Date? {
        
        // format of the dates recieved from Time To Score
        let dateForm: DateFormatter = DateFormatter()
        
        dateForm.locale = Constants.EN_US_POSIX
        dateForm.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateForm.timeZone = Constants.TIMEZONE
        
        return dateForm.date(from: date! + " "  + time!)
    }
    
    // Creates a user friendly formatted date for the game.
    var userFriendlyDate: String? {
        // user friendly date format
        let userFormat = DateFormatter()
        userFormat.locale = Constants.EN_US_POSIX
        userFormat.timeZone = Constants.TIMEZONE
        userFormat.dateStyle = .short
        userFormat.timeStyle = .short
        
        return userFormat.string(from: gameDate!)
    }
    
    init() {
        gameId = ""
        rink = ""
        homeTeam = ""
        awayTeam = ""
    }
    
    init(id: String, rinkName: String, home: String, away: String) {
        gameId = id
        rink = rinkName
        homeTeam = home
        awayTeam = away
    }
    
    //
    // Converts the game's date string into a Date object with format "YYYY-MM-dd"
    //
    // @return: Date object representing the game's start date.
    //          Nil if conversion failed.
    //
    func convertGameDate() -> Date? {
        let dateForm: DateFormatter = DateFormatter()
        dateForm.dateFormat = "YYYY-MM-dd"
        
        return dateForm.date(from: self.date!)
    }
    
    func isLiveGame() -> Bool {
        var ret: Bool = false
        
        let timeForm: DateFormatter = DateFormatter()
        timeForm.dateFormat = "H:mm:ss"
        let calendar: Calendar = Calendar.current
        
        let dateForm: DateFormatter = DateFormatter()
        dateForm.dateFormat = "YYYY-MM-dd"
        
        // get current date (format doesnt match the format of dates from the server)
        let todayDate = Date()
        
        // convert the current date into the correct format
        let today = dateForm.date(from: dateForm.string(from: todayDate))
        
        // get past 12 hours date so we get cames that occured earlier in the day
        let now = calendar.date(byAdding: .hour, value: 0, to: today!)
        
        // get past 12 hours date so we get cames that occured earlier in the day
        let next2Hours = calendar.date(byAdding: .hour, value: 2, to: today!)
    
        
        // get game date
        if self.date != nil {
            
            // get date obj from game's date string
            guard let gameDate = convertGameDate() else { return false }
            
            // Check if the game's date is in a week from today
            if now != nil && next2Hours != nil
                && (now!...next2Hours!).contains(gameDate) {
                ret = true
            }
        }
        
        return ret

    }
    
    //
    // Determines if the game is going to start within a certain amount of days.
    // The range is determined by the UPCOMING_GAME_RANGE value in the Constants class
    // 
    // @return: true if the game's start date is between [today's date, today's date + UPCOMING_GAME_RANGE] 
    //
    func isUpcomingGame() -> Bool {
        var ret: Bool = false
        
        let timeForm: DateFormatter = DateFormatter()
        timeForm.dateFormat = "H:mm:ss"
        let calendar: Calendar = Calendar.current
        
        let dateForm: DateFormatter = DateFormatter()
        dateForm.dateFormat = "YYYY-MM-dd"
        
        // get current date (format doesnt match the format of dates from the server)
        let todayDate = Date()
        
        // convert the current date into the correct format
        let today = dateForm.date(from: dateForm.string(from: todayDate))
        
        // get past 12 hours date so we get cames that occured earlier in the day
        let past12Hours = calendar.date(byAdding: .hour, value: -12, to: today!)
        
        // Date in a week from today
        // TODO: CHANGE VALUE TO 7 FOR WEEK INCREMENT
        let nextWeekDate: Date? =
            calendar.date(byAdding: .day,
                          value: Constants.UPCOMING_GAME_RANGE,
                          to: today!)
        
        
        // get game date
        if self.date != nil {
            
            // get date obj from game's date string
            guard let gameDate = convertGameDate() else { return false }
            
            // Check if the game's date is in a week from today
            if nextWeekDate != nil
                && (past12Hours!...nextWeekDate!).contains(gameDate) {
                ret = true
            }
        }
        
        return ret
    }
    
    /**
     *  Sorts games in descending order of their date and time.
     */
    static func sortGames(a: GameModel, b: GameModel) -> ComparisonResult {
        // gets current calendar and is used to compare dates
        let calendar: Calendar = Calendar.current
        
        // format for time
        let timeForm: DateFormatter = DateFormatter()
        timeForm.dateFormat = "H:mm:ss"
        
        // format for date
        let dateForm: DateFormatter = DateFormatter()
        dateForm.dateFormat = "YYYY-MM-dd"
        
        // Game A's date
        let aDate = dateForm.date(from: a.date!)!
        
        // Game B's date
        let bDate =  dateForm.date(from: b.date!)!
        
        
        // Check if the games are on the same day
        if calendar.compare(aDate, to: bDate, toGranularity: .day) == .orderedSame {
            // sort by the game start time
            return calendar.compare(timeForm.date(from: a.time!)!, to: timeForm.date(from: b.time!)!, toGranularity: .minute)
            
        }
        
        
        // sort by game start date
        return calendar.compare(aDate, to: bDate, toGranularity: .minute)
    }
}
