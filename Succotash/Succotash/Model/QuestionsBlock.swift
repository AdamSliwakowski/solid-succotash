//
//  QuestionsBlock.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 22.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import SwiftyJSON

struct QuestionsBlock {
    var isMandatory: Bool
    var questions: [Question]
    var isFinished: Bool {
        return questions.filter { $0.answer == nil }.count == 0
    }
    var size: Int {
        return questions.count
    }
    
    init(json: JSON) {
        isMandatory = json["is_mandatory"].boolValue
        questions = json["questions"].arrayValue.map { Question(json: $0) }
    }
}
