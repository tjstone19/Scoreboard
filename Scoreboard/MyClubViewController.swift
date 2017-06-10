//
//  MyClubViewController.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/7/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import UIKit

class MyClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gamesTable: UITableView!
    
    // background image
    var background = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesTable.removeEmptyLines()
        
        // set up background
        setupBackground()
    }
    
    private func setupBackground() {
        // set up background
        background.image = #imageLiteral(resourceName: "background-ice1.jpg")
        background.alpha = 0.4
        gamesTable.backgroundView = background
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
