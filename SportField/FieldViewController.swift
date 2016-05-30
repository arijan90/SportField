//
//  FieldViewController.swift
//  SportField
//
//  Created by Arijan Ljoki on 29. 05. 16.
//  Copyright © 2016 Arijan Ljoki. All rights reserved.
//

import Foundation
import UIKit

class FieldViewController: UIViewController, MatchPitchProtocol {
    
    @IBOutlet weak var fieldImageView: UIImageView!
    
    var scoreLabel: UILabel?
    var screenHeightCenter: CGFloat?
    var screenWidthCenter: CGFloat?
    
    var animationInProgress: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if scoreLabel == nil {
            createLabel()
        }
    }
    
    func createLabel() {
        screenHeightCenter = self.view.frame.size.height / 2.0
        screenWidthCenter = self.view.frame.size.width / 2.0
        
        scoreLabel = UILabel(frame: CGRectMake(-200, screenHeightCenter! - 10, 200, 20))
        scoreLabel!.text = "0 : 0"
        scoreLabel!.textAlignment = NSTextAlignment.Center
        self.view.addSubview(scoreLabel!)
    }
    
    func setResultForHome(home: NSNumber, andAway away: NSNumber) {
        if animationInProgress == true {
            return
        }
        
        animationInProgress = true
        
        let labelWidth = (scoreLabel?.frame.width)!
        self.scoreLabel!.center.x = -labelWidth
        UIView.animateWithDuration(1, animations: {
            self.scoreLabel!.center.x = self.screenWidthCenter!
            }) { (finished) in
                UIView.animateWithDuration(1, animations: {
                    self.scoreLabel?.alpha = 0
                    }, completion: { (finished) in
                        UIView.animateWithDuration(1, animations: {
                            self.scoreLabel?.alpha = 1
                            self.scoreLabel?.text = "\(home) : \(away)"
                            }, completion: { (finished) in
                                UIView.animateWithDuration(1, animations: {
                                    self.scoreLabel!.center.x = self.screenWidthCenter! * 2 + labelWidth
                                    }, completion: { (finished) in
                                        self.animationInProgress = false
                                })
                        })
                })
                
                self.view.layoutIfNeeded()
        }
    }
}