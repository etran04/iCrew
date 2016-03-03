//
//  AvailNumSeatCell.swift
//  CruApp
//
//  Created by Eric Tran on 3/1/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class AvailNumSeatCell: UITableViewCell {
    
    @IBOutlet weak var numSeatsLabel: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.value = 0
        numSeatsLabel.text = String(Int(stepper.value))
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func stepperPressed(sender: AnyObject) {
        numSeatsLabel.text = String(Int(stepper.value))
    }
    
}
