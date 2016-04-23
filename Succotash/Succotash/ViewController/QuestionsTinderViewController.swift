//
//  QuestionsTinderViewController.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 23.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import UIKit
import Koloda
import SwiftyTimer

class QuestionsTinderViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer: NSTimer?
    var startTime: NSDate!
    var expirationTime: Double = 10.seconds
    var provider: QuestionsBlocksProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard kolodaView.currentCardIndex > 0 else { return }
        goToNextBlock()
    }
}

extension QuestionsTinderViewController {
    private func configure() {
        configureTimer()
        provider = QuestionsBlocksProvider()
        provider.next()
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }
    
    private func goToNextBlock() {
        configureTimer()
        saveCurrentBlock()
        provider.index += 1
        provider.next()
        if provider.current == nil {
            finish()
        } else {
            kolodaView.resetCurrentCardIndex()
            resetPageControl()
        }
    }
}
    
extension QuestionsTinderViewController {
    private func resetPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = provider.current!.size
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
}

extension QuestionsTinderViewController {
    private func configureTimer() {
        startTime = NSDate()
        timer?.invalidate()
        timer = NSTimer.after(expirationTime, timerHandler)
    }
    
    private func timerHandler() {
        goToNextBlock()
    }
}

extension QuestionsTinderViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        if provider.index + 1 == provider.blocks!.count {
            finish()
        } else {
            presentWaitingViewController()
        }
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        switch direction {
        case .Left: setAnswerForCurrentQuestion(false)
        case .Right: setAnswerForCurrentQuestion(true)
        case .None: break
        }
        pageControl.currentPage = Int(index + 1)
    }
}

extension QuestionsTinderViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(provider.current!.size)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let cardView = NSBundle.mainBundle().loadNibNamed("QuestionCard", owner: self, options: nil)[0] as! QuestionCard
        cardView.configure(provider.current!.questions[Int(index)])
        return cardView
    }
}

extension QuestionsTinderViewController {
    private func setAnswerForCurrentQuestion(answer: Bool) {
        let currentIndex = kolodaView.currentCardIndex - 1
        provider.current!.questions[currentIndex].answer = answer
    }
    
    private func saveCurrentBlock() {
        if let currentBlock = provider.current {
            provider.blocks![provider.currentBlockIndex] = currentBlock
        }
    }
    
    private func presentWaitingViewController() {
        let waitingVC = storyboard?.instantiateViewControllerWithIdentifier("WaitingViewController") as! WaitingViewController
        configureWaitingVC(waitingVC)
        presentViewController(waitingVC, animated: true, completion: nil)
    }
    
    private func configureWaitingVC(vc: WaitingViewController) {
        let timePassed = NSDate().timeIntervalSinceDate(startTime)
        provider.current != nil ? vc.configureTimeLeft(timePassed) : vc.configureWithoutTimer()
    }
    
    private func finish() {
        timer?.invalidate()
        timer = nil
        let waitingVC = storyboard?.instantiateViewControllerWithIdentifier("WaitingViewController") as! WaitingViewController
        waitingVC.configureWithoutTimer()
        presentViewController(waitingVC, animated: true, completion: nil)
    }
}
