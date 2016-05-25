//
//  DriverStatusCell.swift
//  CruApp
//
//  Created by Eric Tran on 5/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class DriverStatusCell: UITableViewCell {

    @IBOutlet weak var departLoc2: UILabel!
    @IBOutlet weak var departLoc1: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var numSeats: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
