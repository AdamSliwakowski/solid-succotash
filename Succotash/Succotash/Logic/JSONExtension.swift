//
//  JSONExtension.swift
//  Succotash
//
//  Created by Adam Śliwakowski on 22.04.2016.
//  Copyright © 2016 sliwakowski. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    static func read(filename: String) -> JSON {
        guard let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") else { return JSON("") }
        let jsonData = NSData(contentsOfFile:path)
        return JSON(data: jsonData!)
    }
}