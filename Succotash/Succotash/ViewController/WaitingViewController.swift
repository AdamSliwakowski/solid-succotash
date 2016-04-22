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
    private var timer: NSTimer!
    private var timeLeft = 80 {
        didSet {
            configureTimeLeftText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    private func configureTimer() {
        NSTimer.after(10.seconds) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        timer = NSTimer.every(1.second) {
            self.timeLeft = self.timeLeft - 1
        }
    }
    
    private func configureTimeLeftText() {
        let minutes = Int(timeLeft / 60)
        let seconds = timeLeft - (minutes * 60)
        timeLeftLabel.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}
