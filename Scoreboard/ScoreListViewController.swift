//
//  ScoreListViewController.swift
//  Scoreboard
//

import UIKit


class ScoreListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scoreTable: UITableView!
    
    // Determines if the score list is for home or away team
    var isHome: Bool = true
    
    // Set by the Scoreboard VC
    var pusherManager: BackendManager?
    
    // Contains list of goal information
    var goals: [ScoreModel] = [ScoreModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called by pusher manager when it receives a goal event.
    func updateUI() {
        if isHome {
            goals = (pusherManager?.homeGoals)!
        }
        else {
            goals = (pusherManager?.awayGoals)!
        }
        
        goals.sort(by:
        {
            let dateForm: DateFormatter = DateFormatter()
            dateForm.dateFormat = "mm:ss"
            let calendar: Calendar = Calendar.current
            
            // Check for same periods
            if Int($0.period!)! == Int($1.period!)! {
                var firstComp = calendar.component(.minute,
                                                   from: dateForm.date(from: $0.time!)!)
                var secondComp = calendar.component(.minute,
                                                    from: dateForm.date(from: $1.time!)!)
                // Check for same minutes
                if firstComp == secondComp {
                    // Sort by seconds
                    firstComp = calendar.component(.second,
                                                   from: dateForm.date(from: $0.time!)!)
                    secondComp = calendar.component(.second,
                                                    from: dateForm.date(from: $1.time!)!)
                    return firstComp < secondComp
                }
                // Sort by minute if minutes are not the same
                else  {
                    return firstComp < secondComp
                }
            }
            // Sort by period if periods are not the same
            else {
               return Int($0.period!)! < Int($1.period!)!
            }
        })
        
        scoreTable.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScoreListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreListTableViewCell
        
        // Configure the cell...
        cell.periodLabel.text = goals[indexPath.row].period
        cell.timeLabel.text = goals[indexPath.row].time
        cell.goalScorerLabel.text = goals[indexPath.row].goalScorer
        cell.assist1Label.text = goals[indexPath.row].assist1
        cell.assist2Label.text = goals[indexPath.row].assist2
        
        return cell
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
