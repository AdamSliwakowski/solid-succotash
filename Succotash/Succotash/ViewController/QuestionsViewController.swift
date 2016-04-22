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
    
    var questionsBlock: QuestionsBlock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsBlock = JSON.read("questions")["blocks"].arrayValue.map { QuestionsBlock(json: $0) }.first!
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
    
    private func configureButtonsForCurrentQuestion() {
        let pageWidth = collectionView.frame.width
        let page = Int(floor(collectionView.contentOffset.x / pageWidth))
        let questionAnswered = questionsBlock.questions[page].answer != nil
        [yesButton, noButton].forEach { button in
            UIView.animateWithDuration(0.3, animations: { button.alpha = CGFloat(questionAnswered ? 0.5 : 1) })
            button.enabled = !questionAnswered
        }
    }
    
    private func scrollToNextQuestion() {
        let currentIndex = collectionView.indexPathsForVisibleItems().first!.row
        let newIndex = currentIndex + 1
        if (0..<questionsBlock.questions.count).contains(newIndex) {
            let nextIndexPath = NSIndexPath(forItem: newIndex, inSection: 0)
            collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Left, animated: true)
        } else {
            configureButtonsForCurrentQuestion()
        }
    }
}

extension QuestionsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsBlock.questions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionCell
        cell.configure(questionsBlock.questions[indexPath.row])
        return cell
    }
}

extension QuestionsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        configureButtonsForCurrentQuestion()
    }
}
