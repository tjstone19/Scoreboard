//
//  GamesListViewController.swift
//  Scoreboard
//


import UIKit

class GamesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segController: UISegmentedControl!
    
    
    // displays the list of games currently under way
    @IBOutlet weak var gamesTable: UITableView!
    
    // Manages the connection with pusher
    var pusherManager: BackendManager!
    
    // Updated by Pusher Manager when game data is received.
    // Contains all games from TTS.
    var games: [GameModel] = [GameModel]()
    
    // games that are
    var displayedGames: [GameModel] = [GameModel]()
    
    // games that are live
    var liveGames: [GameModel] = [GameModel]()
    
    // games that are upcoming
    var upcomingGames: [GameModel] = [GameModel]()
    
    // background image for gamesTable
    var background = UIImageView()
    
    // color for nav bar
    let barColor = UIColor(red:0.00, green:0.47, blue:0.71, alpha:1.0)

    
    // Determines if live or upcoming games are displayed in the table view
    // live = 0   upcoming = 1
    enum SelectedView: Int {
        case Live = 0, Upcoming = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add seg controller to nav bar
        self.navigationController?.navigationBar.addSubview(segController)
        
        // Force Portrait mode
        forcePortrait()
        
        background.image = #imageLiteral(resourceName: "background-ice1.jpg")
        background.alpha = 0.4
  
        gamesTable.backgroundView = background
                
        gamesTable.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "aGameCell")
        gamesTable.estimatedRowHeight = 150.0
        gamesTable.rowHeight = UITableViewAutomaticDimension
        
        gamesTable.separatorInset = UIEdgeInsets.zero
        gamesTable.layoutMargins = UIEdgeInsets.zero
        
        // eliminates empty cell separator lines
        self.gamesTable.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
        if pusherManager != nil {
            pusherManager.updateFunction = updateUI
        }
        else {
            // CHANGE THIS LINE FROM TEST MANAGER TO REAL PUSHER MANAGER
            pusherManager = TestPusherManager()
            //pusherManager = PusherManager()

            pusherManager.establishConnection()
            pusherManager.updateFunction = updateUI
        }
    }
    
    private func forcePortrait() {
        // Force Portrait mode
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    /**
     *  Called when this view becomes the first responder.
     *  Deselects any selected rows from the games table.
     *  Unbinds pusher manager from the current game channel.
     */
    override func viewDidAppear(_ animated: Bool) {
       

        // Force Portrait mode
        forcePortrait()
        
        // Deselect row
        if gamesTable.indexPathForSelectedRow != nil {
            self.gamesTable.deselectRow(at: gamesTable.indexPathForSelectedRow!,
                                        animated: true)
        }
        
        // update games list when view becomes first responder
        updateUI()
    }
    
    // MARK:- Seg controller value change
    
    /// Called when the value of the seg controller is switched.
    @IBAction func segControllerSwitched(_ sender: Any) {
        updateDisplayedGames()
    }
    
    
    // MARK:- Game List Update Methods
    
    /// Sets the displayed games list and reloads the table view.
    private func updateDisplayedGames() {
        
        // set displayed games list to live or upcoming based on seg controller
        if segController.selectedSegmentIndex == SelectedView.Live.rawValue {
            displayedGames = liveGames
        }
        else {
            displayedGames = upcomingGames
        }
        
        //displayedGames.sort(by: {$0.0.gameDate! < $0.1.gameDate!})
        
        // reload the table with the new displayed games
        self.gamesTable.reloadData()
    }
    
    /// updates the live and upcoming games lists
    private func updateLiveAndUpcomingGames() {
        
        // reset live/upcoming games list
        liveGames = []
        upcomingGames = []
        
        
        for game in games {
            if game.homeScore != "" || game.awayScore != "" {
                liveGames.append(game)
            }
            else  {
                upcomingGames.append(game)
            }
        }
    }
    
    // Called by pusher manager when an update is received.
    func updateUI() {
        
        // get the new games list from pusher manager
        games = pusherManager.gamesArray
        
        // updates the live and upcoming games lists
        updateLiveAndUpcomingGames()
        
        // set the displayed games list based on the seg controllers value
        updateDisplayedGames()
    }
    
    
    
    // MARK: - Table view data source
    
    // sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
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
    
    //
    //  Number of sections in the game table.
    //
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if displayedGames.count == 0 {
            return 1
        }
        return displayedGames.count
    }
    
    //
    // Constructs the cell to be displayed and populates the label text.
    //
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if displayedGames.count == 0 {
            let cell: UITableViewCell =
                tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "No Games Available"
            
            gamesTable.separatorStyle = .none
            
            return cell
        }
        else {
            let cell: GameCell =
                tableView.dequeueReusableCell(withIdentifier: "aGameCell",
                                              for: indexPath) as! GameCell
            
            // Configure the cell...
            let game = displayedGames[indexPath.row]
            
            cell.rinkLabel.text = game.rink
            cell.homeTeamLabel.text = game.homeTeam
            cell.awayTeamLabel.text = game.awayTeam
            cell.homeScoreLabel.text = game.homeScore
            cell.awayScoreLabel.text = game.awayScore
            
            cell.homeLogo?.image = Constants.getLogo(team: game.homeTeam!)
            cell.awayLogo?.image = Constants.getLogo(team: game.awayTeam!)
            
            cell.dateLabel.text = game.userFriendlyDate!
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            
            gamesTable.separatorStyle = .singleLine
            
            
            
            return cell
        }
    }
    
    
    // MARK:- selected cell at index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (tableView.cellForRow(at: indexPath) as? GameCell) != nil else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        if indexPath.row > displayedGames.count {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let game = self.displayedGames[indexPath.row]
        
        self.pusherManager.bindToGame(gameId: game.gameId!)
        
        self.performSegue(withIdentifier: "gameToScoreboard", sender: self)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "gameToScoreboard" {
            let dest = segue.destination as! ScoreboardViewController
            let selectedGameIndex: IndexPath = self.gamesTable.indexPathForSelectedRow!
            dest.currentGame = displayedGames[selectedGameIndex.row]
            pusherManager.currentGame = displayedGames[selectedGameIndex.row]
            self.pusherManager.updateFunction = dest.updateUI
            dest.pusherManager = self.pusherManager
        }
     }
}



