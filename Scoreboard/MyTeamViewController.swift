//
//  MyTeamViewController.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/7/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class MyTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var gamesTable: UITableView!
    
    // background image
    var background = UIImageView()
    
    // Contains list of games.
    var pusher: BackendManager = (UIApplication.shared.delegate as! AppDelegate).pusherManager
    
    // Contains games with teams from the user's favorite club.
    var displayedGames: [GameModel] = []
    
    // Contains user's preferred club.
    var settings: UserSettings = UserSettings()
    
    // Set if the view is displaying a pop up view.
    var popUp: PopUpPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up background
        setupTable()
    }
    
    
    /**
     *  Display's the drop down menu.
     *  Drop down menu is displayed as a pop up view.
     */
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showPopUp(named: "MenuPopUp")
    }
    
    /**
     *  Updates the list of games for the user's favorite teams
     */
    override func viewDidAppear(_ animated: Bool) {
        
        popUpCallback()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removePopUpView(view: popUp)
    }
    
    /**
     *  Creates a Club pop up view and provides the callback function called when
     *  the pop up view closes.
     */
    private func showPopUp(named: String) {
        let vc: PopUpPresenter =
            UIStoryboard(name: "Scoreboard", bundle: nil)
                .instantiateViewController(withIdentifier: named) as! PopUpPresenter
        
        // assign the current pop up view. 
        // (so we can dismiss the pop up if the user leaves this view)
        self.popUp = vc
        
        // present pop up
        presentPopUp(popOverVC: vc, callback: popUpCallback)
    }
    
    /**
     *  Called when the club or team select pop up views close.
     *  Checks if preferred club/team is set.  Displays club/team select pop up if not set.
     *
     *  Updates displayed games if both club and team are set.
     */
    func popUpCallback() {
        
        // refresh the saved settings
        self.settings.load()
        
        // show club and team pop up views if settings are not set
        if settings.club == nil {
            showPopUp(named: "MyClubPopUpView")
        }
        else if settings.team == nil {
            showPopUp(named: "MyTeamPopUpView")
        }
        else {
            
            // parse the games for games containing the user's team
            self.parseGames(games: self.pusher.gamesArray)
        }
    }
    
    /**
     *  Parses the list of games and adds the games containing
     *  the user's preferred club as the home or away team.
     *
     *  @games: list of games to be parsed
     */
    private func parseGames(games: [GameModel]) {
        var ret: [GameModel] = []
        
        // user's preferred club
        let club = settings.club
        
        let team = settings.team
        
        // check each game for user's club as home or away team
        for game in games {
            
            // check if user's team is playing in this game
            if team == game.division {
                
                if club!.contains(game.homeTeam!) || club!.contains(game.awayTeam!){
                    ret.append(game)
                }
                
            }
        }
        
        // set the tables list of games
        displayedGames = ret
        
        // update the table
        gamesTable.reloadData()
    }
    
    /**
     *  Table appearance set up
     - remove empty cell lines
     - set background image
     - set background opacity
     */
    private func setupTable() {
        
        // register game cell nib file with the table
        gamesTable.register(UINib(nibName: "GameCell", bundle: nil),
                            forCellReuseIdentifier: "aGameCell")
        
        gamesTable.removeEmptyLines()
        
        // set up background
        background.image = #imageLiteral(resourceName: "background-ice1.jpg")
        background.alpha = Constants.BACKGROUND_IMAGE_OPACITY
        gamesTable.backgroundView = background
        
        // layout constraints
        gamesTable.estimatedRowHeight = 150.0
        gamesTable.rowHeight = UITableViewAutomaticDimension
        
        gamesTable.separatorInset = UIEdgeInsets.zero
        gamesTable.layoutMargins = UIEdgeInsets.zero
    }
    
    
    /**
     *  Determines number of rows in the table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return 1 so "no games" cell can be displayed
        if displayedGames.count == 0 {
            return 1
        }
        
        return displayedGames.count
    }
    
    /**
     *  Creates the cell to be displayed at the given row.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        // display no games available cell when there are no games to display
        if displayedGames.count == 0 {
            cell = UITableViewCell()
            cell.textLabel?.text = "No upcoming games for your club"
        }
        else {
            
            let gameCell = tableView.dequeueReusableCell(withIdentifier: "aGameCell") as! GameCell
            
            // Configure the game
            let game = displayedGames[indexPath.row]
            
            gameCell.rinkLabel.text = game.rink
            gameCell.homeTeamLabel.text = game.homeTeam
            gameCell.awayTeamLabel.text = game.awayTeam
            gameCell.homeScoreLabel.text = game.homeScore
            gameCell.awayScoreLabel.text = game.awayScore
            
            gameCell.homeLogo?.image = Constants.getLogo(team: game.homeTeam!)
            gameCell.awayLogo?.image = Constants.getLogo(team: game.awayTeam!)
            
            gameCell.dateLabel.text = game.userFriendlyDate!
            
            // set the return value to the game cell
            cell = gameCell

        }
        
        cell.setBackgroundOpacity()
        
        return cell
    }
    
    
    // MARK:- Cell Height Methods
    
    
    //
    //  Automatically determine size of the cell.
    //
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //
    //  Estimate height for cell.
    //
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension UIViewController {
    /**
     *  Removes the pop up view
     */
    func removePopUpView(view: PopUpPresenter?) {
        // remove pop up view on the screen if popUp is not nil
        if let popUp = view {
            popUp.view.removeFromSuperview()
            popUp.removeFromParentViewController()
        }
    }
}
