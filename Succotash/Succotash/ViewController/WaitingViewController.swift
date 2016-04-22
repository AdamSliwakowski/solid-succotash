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
    private var timeLeft = 10.seconds {
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
    
    func configureTimeLeft(seconds: Double) {
        timeLeft = timeLeft - seconds
    }
    
    private func configureTimer() {
        timer = NSTimer.every(1.second) {
            self.timeLeft = self.timeLeft - 1
            guard Int(self.timeLeft) == 0 else { return }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func configureTimeLeftText() {
        let minutes = Int(timeLeft / 60)
        let seconds = Int(timeLeft) - (minutes * 60)
        timeLeftLabel.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}
