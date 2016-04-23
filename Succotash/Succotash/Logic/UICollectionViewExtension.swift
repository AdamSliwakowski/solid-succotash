//
//  UICollectionViewExtension.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 23.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import UIKit

extension UICollectionView {
    var currentIndexRow: Int {
        return indexPathsForVisibleItems().first!.row
    }
    
    func scrollToBegin() {
        scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Left, animated: true)
    }
}