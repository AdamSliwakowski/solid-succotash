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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var timer: NSTimer?
    var startTime: NSDate!
    var provider: QuestionsBlocksProvider!
    var expirationTime: Double = 10.seconds
    var questionsBlockIndex: Int! {
        didSet {
            provider.index = questionsBlockIndex
            loadQuestionsBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = QuestionsBlocksProvider()
        questionsBlockIndex = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureTimer()
    }
}

extension QuestionsViewController {
    private func loadQuestionsBlock() {
        guard let _ = provider.blocks else { return }
        saveCurrentBlock()
        provider.next()
        reloadCollectionView()
    }
    
    private func saveCurrentBlock() {
        if let currentBlock = provider.current {
            provider.blocks![questionsBlockIndex - 1] = currentBlock
        }
    }
    
    private func reloadCollectionView() {
        guard let _ = provider.current else {
            finish()
            return
        }
        collectionView.reloadData()
        collectionView.scrollToBegin()
        resetPageControl()
    }
    
    private func resetPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = provider.current!.size
    }
}

extension QuestionsViewController {
    private func configureTimer() {
        startTime = NSDate()
        timer?.invalidate()
        timer = NSTimer.after(expirationTime, timerHandler)
    }
    
    private func timerHandler() {
        configureTimer()
        let newIndex = questionsBlockIndex + 1
        questionsBlockIndex = newIndex
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
        provider.current!.questions[currentIndex].answer = answer
        scrollToNextQuestion()
    }
    
    private func scrollToNextQuestion() {
        let currentIndex = collectionView.currentIndexRow
        let newIndex = currentIndex + 1
        if provider.current!.isFinished {
            presentWaitingViewController()
        } else {
            let nextIndexPath = NSIndexPath(forItem: newIndex, inSection: 0)
            pageControl.currentPage = newIndex
            collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Left, animated: true)
        }
    }
}

extension QuestionsViewController {
    private func presentWaitingViewController() {
        let waitingVC = storyboard?.instantiateViewControllerWithIdentifier("WaitingViewController") as! WaitingViewController
        configureWaitingVC(waitingVC)
        presentViewController(waitingVC, animated: true, completion: nil)
    }
    
    private func configureWaitingVC(vc: WaitingViewController) {
        let timePassed = NSDate().timeIntervalSinceDate(startTime)
        questionsBlockIndex = questionsBlockIndex + 1
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

extension QuestionsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.current!.size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionCell
        cell.configure(provider.current!.questions[indexPath.row])
        return cell
    }
}
