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
        
        if (driveTypes != nil) {
            driveTypes.titleFont = UIFont(name: "FreightSansProMedium-Regular", size: 12.0)!
        }
        
        if (driveTypes2 != nil) {
            driveTypes2.titleFont = UIFont(name: "FreightSansProMedium-Regular", size: 12.0)!
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
