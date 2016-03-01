//
//  StartTimePickerCell.swift
//  CruApp
//
//  Created by Eric Tran on 3/1/16.
//  Copyright © 2016 iCrew. All rights reserved.
//
//

import Foundation
import UIKit
import DatePickerCell

class StartTimePickerCell: DatePickerCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.leftLabel.text = "Start Time"
        super.rightLabel.text = "Choose an available time"
        super.datePicker.datePickerMode = .Time
        super.datePicker.minuteInterval = 15
        super.datePicker.addTarget(self, action: "saveDate", forControlEvents: UIControlEvents.AllEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func saveDate() {
        print("save")
    }
    
}
