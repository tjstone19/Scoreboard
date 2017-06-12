//
//  SettingsViewController.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/4/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    // Settings object that saves and loads settings to/from the device
    var settings: UserSettings = UserSettings()
    
    // background image
    var background = UIImageView()
    
    enum CellType: Int {
        case MyClub = 0, MyTeam = 1, Sounds = 2, ScreenSaver = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell types with the settings table
        registerCellNibs()
        
        // set up background
        setupBackground()
        
        // eliminate empty cell lines
        settingsTable.removeEmptyLines()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSettings()
    }
    
    /**
     *  Loads saved settings from the device.
     */
    private func updateSettings() {
        settings.load()
        settingsTable.reloadData()
    }

    
    /**
     *  Sets up the background image for the settings table.
     */
    private func setupBackground() {
        // set up background
        background.image = #imageLiteral(resourceName: "background-ice1.jpg")
        background.alpha = Constants.BACKGROUND_IMAGE_OPACITY
        settingsTable.backgroundView = background
    }
    
    // register cell types with the settings table
    private func registerCellNibs() {
        
        settingsTable.register(UINib(nibName: "MyClubCell", bundle: nil),
                               forCellReuseIdentifier: "MyClubCell")
        
        settingsTable.register(UINib(nibName: "MyTeamCell", bundle: nil),
                               forCellReuseIdentifier: "MyTeamCell")
        
        settingsTable.register(UINib(nibName: "SoundTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "SoundCell")
        
        settingsTable.register(UINib(nibName: "ScreenSaverTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "ScreenSaverCell")
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    // Determines the content and type of cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        // convert
        let setting: CellType = CellType(rawValue: indexPath.row)!
        
        // Determine which type of cell to create
        switch setting {
            
            // My Club
            case .MyClub:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "MyClubCell", for: indexPath)
                
                
                // set detail label for selected club
                cell.detailTextLabel?.text = settings.club ?? "Not Set"
                break
            
            // My Team
            case .MyTeam:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "MyTeamCell", for: indexPath)
                
                // set detail label for selected club
                cell.detailTextLabel?.text = settings.team ?? "Not Set"
                break
            
            // Sounds
            case .Sounds:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
                
                // set switch to settings value
                (cell as! SoundTableViewCell).soundSwitch.isOn = settings.sounds
                break
            
            // Screen Saver
            case .ScreenSaver:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "ScreenSaverCell", for: indexPath) as! ScreenSaverTableViewCell
                
                // set switch to settings value
                (cell as! ScreenSaverTableViewCell).screenSwitch.isOn = settings.screenSaver
                break
        }
        
        // background color
        cell.setBackgroundOpacity()
        
        return cell
    }
    
    /// Instanciates pop up view with the given name
    ///
    /// @name: name of the pop up view controller to create
    private func createPopUpView(name: String) {
        var popOverVC: UIViewController?
        
        switch name {
            case "MyClubPopUpView":
                // create my club pop up view controller
                popOverVC = UIStoryboard(name: "Scoreboard", bundle: nil).instantiateViewController(withIdentifier: name) as! MyClubPopUpView
                
                // set callback function: called when pop up is dismissed
                (popOverVC as! MyClubPopUpView).callback = unwindFromPopUp
                break
            case "MyTeamPopUpView":
                popOverVC = UIStoryboard(name: "Scoreboard", bundle: nil).instantiateViewController(withIdentifier: name) as! MyTeamPopUpView
                
                // set callback function: called when pop up is dismissed
                (popOverVC as! MyTeamPopUpView).callback = unwindFromPopUp
                break
            default:
                // return if no pop up view was created
                return
        }
        
        // present the pop up view
        presentPopUp(popOverVC: popOverVC as! PopUpPresenter, callback: unwindFromPopUp)
    }
   
    /**
     *  Called when the club or team pop up views resign first responder
     */
    func unwindFromPopUp() {
        updateSettings()
    }
    

    // Called when the user selects a table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // convert index to setting cell type
        let setting: CellType = CellType(rawValue: indexPath.row)!
        
        // present pop up view's for club or team
        if setting == .MyClub {
            createPopUpView(name: "MyClubPopUpView")
        }
        else if setting == .MyTeam {
            createPopUpView(name: "MyTeamPopUpView")
        }
        
        // unhighlight selected cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIViewController {
    /**
     *  Presents the pop up view controller over this view.
     *
     * @popOverVC: pop up view controller to present.
     */
    func presentPopUp(popOverVC: PopUpPresenter, callback: @escaping () -> Void) {
        
        let popOverVC = popOverVC
        
        popOverVC.callback = callback
        
        // add pop up as child view
        self.addChildViewController(popOverVC as UIViewController)
        popOverVC.view.frame = self.view.frame
        
        
        // add pop up to view
        self.view.addSubview((popOverVC.view)!)
        
        // set pop up view's parent view controller
        popOverVC.didMove(toParentViewController: self)
    }
}
