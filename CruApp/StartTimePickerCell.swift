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
        super.leftLabel.text = "Departure time"
        super.rightLabel.text = "Choose the ideal time"
        super.datePicker.minuteInterval = 1
        
        super.datePicker.minimumDate = NSDate()
        super.datePicker.addTarget(self, action: #selector(StartTimePickerCell.saveDate), forControlEvents: UIControlEvents.AllEvents)
        
        super.leftLabel.font = UIFont(name: "FreightSansProMedium-Regular", size: 17.0)
        super.rightLabel.font = UIFont(name: "FreightSansProMedium-Regular", size: 17.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func selectedInTableView(tableView: UITableView) {
        super.selectedInTableView(tableView)
        // initialized choice to first option when cell is opened for the first time
        if (super.rightLabel.text == "Choose the ideal time") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            rightLabel.text = dateFormatter.stringFromDate(super.datePicker.date)
        }
    }
    
    func saveDate() {
    }
    
}
