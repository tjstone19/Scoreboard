//
//  ScoreboardViewController.swift
//  Scoreboard
//


import UIKit
import UserNotifications
import AVFoundation

class ScoreboardViewController: UIViewController, AVAudioPlayerDelegate {
    
    // Home Labels
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var homeShotsLabel: UILabel!
    @IBOutlet weak var homePenNum1Label: UILabel!
    @IBOutlet weak var homePenTime1Label: UILabel!
    @IBOutlet weak var homePenNum2Label: UILabel!
    @IBOutlet weak var homePenTime2Label: UILabel!
    @IBOutlet weak var homeLogo: UIImageView!
    
    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    
    // Away Labels
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var awayShotsLabel: UILabel!
    @IBOutlet weak var awayPenNum1Label: UILabel!
    @IBOutlet weak var awayPenTime1Label: UILabel!
    @IBOutlet weak var awayPenNum2Label: UILabel!
    @IBOutlet weak var awayPenTime2Label: UILabel!
    @IBOutlet weak var awayLogo: UIImageView!
    
    // Contains data for current game being viewed.
    var currentGame: GameModel?
    
    var gameData: ScoreboardModel?
    
    // Set by the game view controller.
    // Manages the connection with pusher
    var pusherManager: BackendManager = (UIApplication.shared.delegate as! AppDelegate).pusherManager
    
    var firstUpdate: Bool = true
    
    var player: AVAudioPlayer?
    
    // stores the value of the old nav bar color
    //  restores the nav bar color in prepare for segue method
    var navColor: UIColor?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust nav bar properties
        setUpNavBar()
        
        // Force landscape mode
        forceLandscape()
        
        // Set update function for pusher manager to call when there is an update
        pusherManager.updateFunction = updateUI
        
        // set the game to be displayed
        currentGame = pusherManager.currentGame
        
        // Set nav bar title text
        self.navigationItem.title = (currentGame?.homeTeam)! + " vs " + (currentGame?.awayTeam)!
        
        
        if let homeImage = Constants.getLogo(team: (currentGame?.homeTeam)!) {
            homeLogo.image = homeImage
        }
        
        if let awayImage = Constants.getLogo(team: (currentGame?.awayTeam)!) {
            awayLogo.image = awayImage
        }
        
        firstUpdate = true
        updateUI()
    }
    
    private func forceLandscape() {
        // Force landscape mode
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    private func setUpNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        // set back button color to black
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // hide nav bar on swipe
        navigationController?.hidesBarsOnTap = true
        
        
        // hide tab bar on bottom
        tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    // Called before the view controller resigns first responder.
    // Restores the navigation bar properties back to default.
    override func viewWillDisappear(_ animated: Bool) {
        // nav bar to blue
        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.47, blue:0.71, alpha:1.0)
        
        // nav bar title color to white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
       
        // set back button color to white
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // hide nav bar when tapped
        navigationController?.hidesBarsOnTap = false
        
        // hide tab bar on bottom
        tabBarController?.hidesBottomBarWhenPushed = false
        
        // set navigation bar visible
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
   
    // Updates pusher managers function to scoreboard view updateUI() function.
    // Resets the goals missed count to 0
    // Updates the UI to display current game status.
    override func viewDidAppear(_ animated: Bool) {
        pusherManager.updateFunction = updateUI
        setUpNavBar()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                            successfully flag: Bool) {
        self.player?.stop()
        self.player = nil
    }
    
    func playGoalSound() {
        
        
        let url = Bundle.main.url(forResource: "goal-horn", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if player == nil {
                return
            }
            
            player?.prepareToPlay()
            player?.play()
            player?.delegate = self
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func sendGoalNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "Goal Scored!"
        
        content.body = (currentGame?.homeTeam)! + " " + homeScoreLabel.text!
            + " " + (currentGame?.awayTeam)! + " " + awayScoreLabel.text!
        
        content.badge = 1
        
        content.categoryIdentifier = "goalNotification"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let requestIdentifier = "goalRequest"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            // handle error
        })
    }
    
    // Called by pusher manager when an update is received.
    func updateUI() {
        let model: ScoreboardModel = pusherManager.scoreboard
        let _: String? = homeScoreLabel.text
        let _: String? = awayScoreLabel.text
        
        homeScoreLabel.text = model.homeScore
        homeShotsLabel.text = model.homeShots
        homePenNum1Label.text = model.homeP1Number
        homePenTime1Label.text = model.homeP1Time
        homePenNum2Label.text = model.homeP2Number
        homePenTime2Label.text = model.homeP2Time
        
        awayScoreLabel.text = model.awayScore
        awayShotsLabel.text = model.awayShots
        awayPenNum1Label.text = model.awayP1Number
        awayPenTime1Label.text = model.awayP1Time
        awayPenNum2Label.text = model.awayP2Number
        awayPenTime2Label.text = model.awayP2Time
        
        clockLabel.text = model.time
        periodLabel.text = model.period
        
        // Notify the user that a goal was scored
       /* if homeScoreLabel.text != oldHomeScore ||
            awayScoreLabel.text != oldAwayScore {
            (UIApplication.shared.delegate as! AppDelegate).goalsMissed += 1
            sendGoalNotification()
            
            // Dont play sound on first update
            if !firstUpdate {
                playGoalSound()
            }
        }
        
        firstUpdate = false*/
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "homeScore":
            let dest: ScoreListViewController = segue.destination as! ScoreListViewController
            pusherManager.updateFunction = dest.updateUI
            dest.isHome = true
            dest.pusherManager = self.pusherManager
            break
        case "awayScore":
            let dest: ScoreListViewController = segue.destination as! ScoreListViewController
            pusherManager.updateFunction = dest.updateUI
            dest.isHome = false
            dest.pusherManager = self.pusherManager
            break
        case "homePenalty":
            let dest: PenaltyListViewController = segue.destination as! PenaltyListViewController
            pusherManager.updateFunction = dest.updateUI
            dest.isHome = true
            dest.pusherManager = self.pusherManager
            break
        case "awayPenalty":
            let dest: PenaltyListViewController = segue.destination as! PenaltyListViewController
            pusherManager.updateFunction = dest.updateUI
            dest.isHome = false
            dest.pusherManager = self.pusherManager
            break
        case "homeRoster":
            let dest: RosterViewController = segue.destination as! RosterViewController
            dest.isHome = true
            pusherManager.updateFunction = dest.updateUI
            dest.pusherManager = self.pusherManager
            break
        case "awayRoster":
            let dest: RosterViewController = segue.destination as! RosterViewController
            dest.isHome = false
            pusherManager.updateFunction = dest.updateUI
            dest.pusherManager = self.pusherManager
            break
        default:
            print("****** Scoreboard Unkown Segue *******")
            break
            
        }
    }

 
}
