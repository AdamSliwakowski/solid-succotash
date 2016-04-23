//
//  QuestionsBlocksProvider.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 23.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import SwiftyJSON

class QuestionsBlocksProvider: NSObject {
    var current: QuestionsBlock?
    var blocks: [QuestionsBlock]?
    var index: Int = 0
    var currentBlockIndex: Int {
        return blocks!.indexOf({ $0.questions.first!.text == current!.questions.first!.text }) ?? 0
    }
    
    override init() {
        blocks = JSON.read("questions")["blocks"].arrayValue.map { QuestionsBlock(json: $0) }
    }
    
    func next() {
        guard blocks!.count > index else { current = nil; return }
        var newBlock = blocks![index]
        let notFinishedMandatoryBlock = blocks!.filter { $0.isMandatory && !$0.isFinished }.first
        if let notFinishedMandatoryBlock = notFinishedMandatoryBlock where !newBlock.isMandatory {
            newBlock = notFinishedMandatoryBlock
        }
        current = newBlock
    }
}