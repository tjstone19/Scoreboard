//
//  MenuPopUp.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/14/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class MenuPopUp: PopUpPresenter, UITableViewDelegate, UITableViewDataSource {

    // Displays the list of menu items
    @IBOutlet weak var menuTable: UITableView!
    
    // Items displayed in the drop down menu.
    var menuItems = ["My Club", "My Team"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the background clear so the presenting view controller is not covered.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        
        menuTable.removeEmptyLines()
        
    }
    
    /// Called when the close button is pressed
    /// Removes this view from the heirarchy.
    @IBAction func closePressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    
   
    //MARK:- Table View Data Source Methods
    
    
    // Number of rows in the table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    
    // Create cell and fill out cell content
    func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        // set the club name
        cell.textLabel?.text = menuItems[indexPath.row]
        
        return cell
    }
    
    // Called when the user taps on a cell.
    // Save club to device and dismisses this view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // pop up view to present based on which menu item was selected
        var popUp: PopUpPresenter?
        
        var parentView: UIViewController?
        
        // determine which menu item was selected
        switch menuItems[indexPath.row] {
            
        case "My Club":
            // create my club pop up view
            popUp =
                UIStoryboard(name: "Scoreboard", bundle: nil)
                    .instantiateViewController(withIdentifier: "MyClubPopUpView") as! MyClubPopUpView
            break
            
        case "My Team":
            // create my club pop up view
            popUp =
                UIStoryboard(name: "Scoreboard", bundle: nil)
                    .instantiateViewController(withIdentifier: "MyTeamPopUpView") as! MyTeamPopUpView
            break
            
        default:
            break
        }
        
        // check for parent view
        parentView = self.parent
        
        if parentView != nil {
            parentView?.presentPopUp(popOverVC: popUp!, callback: callback!)
        }
        
        
        // remove this pop up view from nav stack
        self.removeAnimate()
    }
    
}
