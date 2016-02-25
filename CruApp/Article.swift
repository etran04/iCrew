//
//  Resource.swift
//  CruApp
//
//  Created by Tammy Kong on 2/21/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct Article {
    var url: String
    var type: String
    var title: String
    var tags = [String]()
    
    init(url: String, type: String, title: String, tags: [String]) {
        self.url = url
        self.type = type
        self.title = title
        self.tags += tags
    }
}
