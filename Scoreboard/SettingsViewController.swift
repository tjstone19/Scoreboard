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
    

    
    private func setupBackground() {
        // set up background
        background.image = #imageLiteral(resourceName: "background-ice1.jpg")
        background.alpha = 0.4
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
                // TODO set detail label for selected club
                break
            // My Team
            case .MyTeam:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "MyTeamCell", for: indexPath)
                break
            // Sounds
            case .Sounds:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath) as! SoundTableViewCell
                break
            // Screen Saver
            case .ScreenSaver:
                cell = settingsTable.dequeueReusableCell(withIdentifier: "ScreenSaverCell", for: indexPath) as! ScreenSaverTableViewCell
                break
        }
        
        // background color
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        return cell
    }
    
    // Instanciates pop up view with the given name
    private func createPopUpView(name: String) {
        // create my club pop up view controller
        let popOverVC = UIStoryboard(name: "Scoreboard", bundle: nil).instantiateViewController(withIdentifier: name)
        
        // add pop up as child view
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        
        // add pop up to view
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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
