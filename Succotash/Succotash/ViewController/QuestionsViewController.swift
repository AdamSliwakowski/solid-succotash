//
//  QuestionsViewController.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 22.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyTimer

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var timer: NSTimer?
    var startTime: NSDate!
    var coordinator: QuestionsBlocksProvider!
    var expirationTime: Double = 10.seconds
    var questionsBlockIndex: Int! {
        didSet {
            coordinator.index = questionsBlockIndex
            loadQuestionsBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = QuestionsBlocksProvider()
        questionsBlockIndex = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTimer()
    }
}

extension QuestionsViewController {
    private func loadQuestionsBlock() {
        guard let _ = coordinator.blocks else { return }
        saveCurrentBlock()
        coordinator.next()
        reloadCollectionView()
    }
    
    private func saveCurrentBlock() {
        if let currentBlock = coordinator.current {
            self.coordinator.blocks![questionsBlockIndex - 1] = currentBlock
        }
    }
    
    private func reloadCollectionView() {
        guard let _ = coordinator.current else {
            finish()
            return
        }
        collectionView.reloadData()
        collectionView.scrollToBegin()
    }
}

extension QuestionsViewController {
    private func configureTimer() {
        startTime = NSDate()
        timer?.invalidate()
        timer = NSTimer.after(expirationTime, timerHandler)
    }
    
    private func timerHandler() {
        self.configureTimer()
        let newIndex = questionsBlockIndex + 1
        self.questionsBlockIndex = newIndex
    }
}

extension QuestionsViewController {
    @IBAction func handleNoButton() {
        setAnswerForCurrentQuestion(false)
    }
    
    @IBAction func handleYesButton() {
        setAnswerForCurrentQuestion(true)
    }
    
    private func setAnswerForCurrentQuestion(answer: Bool) {
        let currentIndex = collectionView.currentIndexRow
        coordinator.current!.questions[currentIndex].answer = answer
        scrollToNextQuestion()
    }
    
    private func scrollToNextQuestion() {
        let currentIndex = collectionView.currentIndexRow
        let newIndex = currentIndex + 1
        if coordinator.current!.isFinished {
            presentWaitingViewController()
        } else {
            let nextIndexPath = NSIndexPath(forItem: newIndex, inSection: 0)
            collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Left, animated: true)
        }
    }
}

extension QuestionsViewController {
    private func presentWaitingViewController() {
        let waitingVC = storyboard?.instantiateViewControllerWithIdentifier("WaitingViewController") as! WaitingViewController
        presentViewController(waitingVC, animated: true) { [unowned self] in self.configureWaitingVC(waitingVC) }
    }
    
    private func configureWaitingVC(vc: WaitingViewController) {
        let timePassed = NSDate().timeIntervalSinceDate(self.startTime)
        self.questionsBlockIndex = self.questionsBlockIndex + 1
        self.coordinator.current != nil ? vc.configureTimeLeft(timePassed) : vc.configureWithoutTimer()
    }
    
    private func finish() {
        timer?.invalidate()
        timer = nil
        let waitingVC = storyboard?.instantiateViewControllerWithIdentifier("WaitingViewController") as! WaitingViewController
        presentViewController(waitingVC, animated: true) {
            waitingVC.configureWithoutTimer()
        }
    }
}

extension QuestionsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coordinator.current!.size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionCell
        cell.configure(coordinator.current!.questions[indexPath.row])
        return cell
    }
}
