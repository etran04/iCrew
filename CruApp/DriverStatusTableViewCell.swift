//
//  DriverViewCell.swift
//  CruApp
//
//  Created by Tammy Kong on 2/4/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class DriverStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelDriver: UIButton!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var availableSeats: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
