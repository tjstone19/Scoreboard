//
//  RosterViewController.swift
//  Scoreboard
//

import Foundation
import UIKit

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Determines if roster is for home or away team
    var isHome: Bool = true
    
    // Contains list of players to be displayed
    var roster: [PlayerModel] = [PlayerModel]()
    
    // Receives updates from server
    var pusherManager: BackendManager!
    
    // background image for rosterTable
    var background = UIImageView()

    
    @IBOutlet weak var rosterTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pusherManager.updateFunction = updateUI
        
        // background image
        background.image = #imageLiteral(resourceName: "background-ice1.jpg")
        background.alpha = 0.4
        
        rosterTable.backgroundView = background
        
        // eliminates empty cell separator lines
        self.rosterTable.tableFooterView = UIView()
        
        updateUI()
    }
    
    func updateUI() {
        if isHome {
            roster = pusherManager.homeRoster
        }
        else {
            roster = pusherManager.awayRoster
        }
        
        if roster.count > 0 {
            roster = roster.sorted(by: {
                if $0.number != "" && $1.number != "" {
                    return Int($0.number!)! < Int($1.number!)!
                }
                else {
                    return $0.name! < $1.name!
                }
            })
        }
        
        
        rosterTable.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roster.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RosterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "rosterCell", for: indexPath) as! RosterTableViewCell
        
        // Configure the cell...
        cell.numberLabel.text = roster[indexPath.row].number
        cell.nameLabel.text = roster[indexPath.row].name
        cell.goalsLabel.text = roster[indexPath.row].goals
        cell.assistsLabel.text = roster[indexPath.row].assists
        cell.pimsLabel.text = roster[indexPath.row].pims
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
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
