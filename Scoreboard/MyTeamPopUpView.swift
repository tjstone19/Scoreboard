//
//  MyTeamPopUpView.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/4/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class MyTeamPopUpView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Callback function to call before this view dismisses itself
    var callBack: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Called when the close button is pressed
    /// Removes this view from the heirarchy.
    @IBAction func closePressed(_ sender: Any) {
        self.removeAnimate()
    }
    
    
    
    //MARK:- Pop Up Animation
    
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                // remove this view from the navigation stack
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    
    //MARK:- Table View Data Source Methods
    
    
    // Number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.TEAMS.count
    }
    
    
    // Create cell and fill out cell content
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        // set the club name
        cell?.textLabel?.text = Constants.TEAMS[indexPath.row]
        
        return cell!
    }
    
    // Called when the user taps on a cell.
    // Save club to device and dismisses this view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // create settings object and load saved settings
        let settings: UserSettings = UserSettings()
        settings.load()
        
        // update favorite team setting
        settings.team = Constants.TEAMS[indexPath.row]
        
        // save the new settings to the device
        settings.save()
        
        // remove this pop up view from nav stack
        self.removeAnimate()
        
        // call the callback function to notify displaying view
        callBack!()
    }
    
}
