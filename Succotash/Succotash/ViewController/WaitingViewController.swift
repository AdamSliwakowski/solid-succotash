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
    
    @IBOutlet weak var timeLeftLabel: UILabel? {
        didSet {
            timeLeftLabel?.text = nil
        }
    }
    var shouldCount: Bool = true
    private var timer: NSTimer?
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
        timer?.invalidate()
    }
}

extension WaitingViewController {
    func configureTimeLeft(seconds: Double) {
        timeLeft = timeLeft - seconds
    }
    
    func configureWithoutTimer() {
        shouldCount = false
        timeLeftLabel?.text = nil
    }
    
    private func configureTimer() {
        guard shouldCount else { return }
        timer = NSTimer.every(1.second, handleTimer)
        configureTimeLeftText()
    }
    
    private func handleTimer() {
        timeLeft = timeLeft - 1
        guard Int(timeLeft) == 0 else { return }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func configureTimeLeftText() {
        guard let timeLeftLabel = timeLeftLabel else { return }
        let minutes = Int(timeLeft / 60)
        let seconds = Int(timeLeft) - (minutes * 60)
        timeLeftLabel.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}
