//
//  DriveTypeCell.swift
//  CruApp
//
//  Created by Eric Tran on 3/1/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import CheckmarkSegmentedControl

class DriveTypeCell: UITableViewCell {

    // outlet to driver q types
    @IBOutlet weak var driveTypes: CheckmarkSegmentedControl!
    
    // outlet to rider q types
    @IBOutlet weak var driveTypes2: CheckmarkSegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
