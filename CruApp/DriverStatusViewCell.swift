//
//  DriverViewCell.swift
//  CruApp
//
//  Created by Tammy Kong on 2/4/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class DriverStatusViewCell: UITableViewCell {


    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var numOfSeats: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
