//
//  QuestionCard.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 23.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import UIKit

class QuestionCard: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(question: Question) {
        configureAppearance()
        textLabel.text = question.text
        imageView.image = UIImage(named: question.image)
    }
    
    private func configureAppearance() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor(white: 0.85, alpha: 1).CGColor
        layer.borderWidth = 1
    }
}

