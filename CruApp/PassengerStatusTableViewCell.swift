//
//  PassengerStatusTableViewCell.swift
//  CruApp
//
//  Created by Tammy Kong on 2/28/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class PassengerStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverNumber: UILabel!
    @IBOutlet weak var departureLoc: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
