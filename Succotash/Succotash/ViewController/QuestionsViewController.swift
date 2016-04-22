//
//  QuestionsViewController.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 22.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var questionsBlock: QuestionsBlock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsBlock = JSON.read("questions")["blocks"].arrayValue.map { QuestionsBlock(json: $0) }.first!
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