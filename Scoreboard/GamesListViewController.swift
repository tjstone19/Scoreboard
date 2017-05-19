//
//  GamesListViewController.swift
//  Scoreboard
//


import UIKit

class GamesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // displays the list of games currently under way
    @IBOutlet weak var gamesTable: UITableView!
    
    // Manages the connection with pusher
    var pusherManager: BackendManager!
    
    // Updated by Pusher Manager when game data is received.
    var games: [GameModel] = [GameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                
        gamesTable.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "aGameCell")
        gamesTable.estimatedRowHeight = 150.0
        gamesTable.rowHeight = UITableViewAutomaticDimension
        
        gamesTable.separatorInset = UIEdgeInsets.zero
        gamesTable.layoutMargins = UIEdgeInsets.zero
        
        // Do any additional setup after loading the view.
        if pusherManager != nil {
            pusherManager.updateFunction = updateUI
        }
        else {
            // CHANGE THIS LINE FROM TEST MANAGER TO REAL PUSHER MANAGER
           // pusherManager = TestPusherManager()
            pusherManager = PusherManager()

            pusherManager.establishConnection()
            pusherManager.updateFunction = updateUI
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *  Called when this view becomes the first responder.
     *  Deselects any selected rows from the games table.
     *  Unbinds pusher manager from the current game channel.
     */
    override func viewDidAppear(_ animated: Bool) {
        // Deselect row
        if gamesTable.indexPathForSelectedRow != nil {
             self.gamesTable.deselectRow(at: gamesTable.indexPathForSelectedRow!,
                                         animated: true)
        }
        
        
        
        // unbind from the current game TODO: UNCOMMENT
        //pusherManager.unbindFromGame()
    }
    
    // Called by pusher manager when an update is received.
    func updateUI() {
        self.games = pusherManager.gamesArray
        
        self.gamesTable.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    // 
    //  Automatically determine size of the cell.
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //
    //  Estimate height for cell.
    //
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //
    //  Number of sections in the game table.
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if games.count == 0 {
            return 1
        }
        return games.count
    }
    
    
    //
    // Constructs the cell to be displayed and populates the label text.
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        if games.count == 0 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
            
            cell.textLabel?.text = "No Games Available"
            
            return cell
        }
        else {
            let cell: GameCell = tableView.dequeueReusableCell(withIdentifier: "aGameCell", for: indexPath) as! GameCell
            
            // Configure the cell...
            
            cell.rinkLabel.text = games[indexPath.row].rink
            cell.homeTeamLabel.text = games[indexPath.row].homeTeam
            cell.awayTeamLabel.text = games[indexPath.row].awayTeam
            cell.homeScoreLabel.text = games[indexPath.row].homeScore
            cell.awayScoreLabel.text = games[indexPath.row].awayScore 
            
            cell.homeLogo?.image = Constants.getLogo(team: games[indexPath.row].homeTeam!)
            cell.awayLogo?.image = Constants.getLogo(team: games[indexPath.row].awayTeam!)
            
            cell.dateLabel.text = games[indexPath.row].userFriendlyDate!
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = self.games[indexPath.row]
        
        self.pusherManager.bindToGame(gameId: game.gameId!)
        
        self.performSegue(withIdentifier: "gameToScoreboard", sender: self)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "gameToScoreboard" {
            let dest = segue.destination as! ScoreboardViewController
            let selectedGameIndex: IndexPath = self.gamesTable.indexPathForSelectedRow!
            dest.currentGame = games[selectedGameIndex.row]
            pusherManager.currentGame = games[selectedGameIndex.row]
            self.pusherManager.updateFunction = dest.updateUI
            dest.pusherManager = self.pusherManager
        }
     }
}
