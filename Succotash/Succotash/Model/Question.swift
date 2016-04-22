//
//  Question.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 22.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import SwiftyJSON

struct Question {
    var text: String
    var image: String
    var answer: Bool?
    var isAnswered: Bool {
        return answer != nil
    }
    
    init(json: JSON) {
        text = json["question"].stringValue
        image = json["image"].stringValue
    }
}
