//
//  QuestionData.swift
//  CruApp
//
//  Created by Mariel Sanchez on 5/12/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

struct QuestionData {
    var ministry: String
    var question: String
    var type: String
    var options: [String]
    var selectedAnswerIndex: Int
    
    init(ministry: String, question: String, type: String, options: [String]!){
        self.ministry = ministry;
        self.question = question;
        self.type = type;
        
        if let opts = options {
            self.options = opts
        }
        else {
            self.options = []
        }
        
        selectedAnswerIndex = 0
    }
}
