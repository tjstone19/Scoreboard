//
//  PopUpPresenter.swift
//  Scoreboard
//
//  Created by T.J. Stone on 6/11/17.
//  Copyright © 2017 T.J. Stone. All rights reserved.
//

import Foundation
import UIKit

class PopUpPresenter: UIViewController {
    var callback: (() -> Void)?
    
    
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

}
