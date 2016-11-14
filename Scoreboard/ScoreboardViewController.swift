//
//  ScoreboardViewController.swift
//  Scoreboard
//
//  Created by T.J. Stone on 11/6/16.
//  Copyright © 2016 T.J. Stone. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController {
    
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
    
    
    //Away Labels
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var awayShotsLabel: UILabel!
    @IBOutlet weak var awayPenNum1Label: UILabel!
    @IBOutlet weak var awayPenTime1Label: UILabel!
    @IBOutlet weak var awayPenNum2Label: UILabel!
    @IBOutlet weak var awayPenTime2Label: UILabel!

    @IBOutlet weak var awayLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
