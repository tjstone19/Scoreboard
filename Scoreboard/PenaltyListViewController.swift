//
//  PenaltyListViewController.swift
//  Scoreboard
//


import UIKit

class PenaltyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var penaltyTable: UITableView!
    
    // Determines if penalty list is for home or away team
    var isHome: Bool = true
    
    // Set by the scoreboard VC
    var pusherManager: PusherManager?
    
    // Contains penalty data
    var penaltys: [PenaltyModel] = [PenaltyModel]()
    
    
    /* Player # and name or “Bench”
     Type of penalty (e.g. minor, major, etc)
     Description of penalty (e.g. Hooking, Charging, Too many men)
     How long the penalty was assessed
     When the penalty started
     When the player is supposed to get off (time and period)
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when pusher manager receives a penalty event
    func updateUI() {
        if isHome {
            penaltys = (pusherManager?.homePenaltys)!
        }
        else {
            penaltys = (pusherManager?.awayPenaltys)!
        }
        
        penaltys.sort(by:
            {
                let dateForm: DateFormatter = DateFormatter()
                dateForm.dateFormat = "mm:ss"
                let calendar: Calendar = Calendar.current
                
                
                if Int($0.period!)! == Int($1.period!)! {
                    var firstComp = calendar.component(.minute,
                                                       from: dateForm.date(from: $0.time!)!)
                    var secondComp = calendar.component(.minute,
                                                        from: dateForm.date(from: $1.time!)!)
                    
                    if firstComp == secondComp {
                        firstComp = calendar.component(.second,
                                                       from: dateForm.date(from: $0.time!)!)
                        secondComp = calendar.component(.second,
                                                        from: dateForm.date(from: $1.time!)!)
                        return firstComp < secondComp
                    }
                    else  {
                        return firstComp < secondComp
                    }
                }
                else {
                    return Int($0.period!)! < Int($1.period!)!
                }
        })
        
        penaltyTable.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return penaltys.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PenaltyListTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "penaltyCell",
                                          for: indexPath) as! PenaltyListTableViewCell
        
        // Configure the cell...
        cell.periodLabel.text = penaltys[indexPath.row].period
        cell.timeLabel.text = penaltys[indexPath.row].time
        cell.playerLabel.text = penaltys[indexPath.row].player
        cell.typeLabel.text = penaltys[indexPath.row].type
        cell.lengthLabel.text = penaltys[indexPath.row].length
        
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
