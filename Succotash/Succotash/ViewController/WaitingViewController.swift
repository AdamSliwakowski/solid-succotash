//
//  WaitingViewController.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 22.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import UIKit
import SwiftyTimer

class WaitingViewController: UIViewController {
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
    }
    
    private func configureTimer() {
        NSTimer.after(3.seconds) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
