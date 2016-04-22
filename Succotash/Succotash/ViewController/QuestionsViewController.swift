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
    var expirationTime: Double = 10.seconds
    var questionsBlock: QuestionsBlock!
    var questionsBlockIndex: Int! {
        didSet {
            loadQuestionsBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsBlockIndex = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTimer()
    }
    
    private func loadQuestionsBlock() {
        let questionBlocks = JSON.read("questions")["blocks"].arrayValue.map { QuestionsBlock(json: $0) }
        guard questionsBlockIndex < questionBlocks.count else {
            questionsBlockIndex = 0
            return
        }
        questionsBlock = questionBlocks[questionsBlockIndex]
        reloadCollectionView()
    }
    
    private func configureTimer() {
        startTime = NSDate()
        timer?.invalidate()
        timer = NSTimer.after(expirationTime, {
            self.questionsBlockIndex = self.questionsBlockIndex + 1
            self.configureTimer()
        })
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
        let currentIndex = collectionView.indexPathsForVisibleItems().first!.row
        questionsBlock.questions[currentIndex].answer = answer
        scrollToNextQuestion()
    }
    
    private func scrollToNextQuestion() {
        let currentIndex = collectionView.indexPathsForVisibleItems().first!.row
        let newIndex = currentIndex + 1
        if questionsBlock.isFinished {
            presentWaitingViewController()
        } else {
            let nextIndexPath = NSIndexPath(forItem: newIndex, inSection: 0)
            collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Left, animated: true)
        }
    }
    
    private func presentWaitingViewController() {
        let waitingVC = storyboard?.instantiateViewControllerWithIdentifier("WaitingViewController") as! WaitingViewController
        presentViewController(waitingVC, animated: true) {
            let timePassed = NSDate().timeIntervalSinceDate(self.startTime)
            waitingVC.configureTimeLeft(timePassed)
            self.questionsBlockIndex = self.questionsBlockIndex + 1
        }
    }
    
    private func reloadCollectionView() {
        collectionView.reloadData()
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Left, animated: true)
    }
}

extension QuestionsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsBlock.size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionCell
        cell.configure(questionsBlock.questions[indexPath.row])
        return cell
    }
}
