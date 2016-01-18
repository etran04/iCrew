//
//  EventViewCell.swift
//  CruApp
//
//  Created by Tammy Kong on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    @IBOutlet var eventName: UILabel!
    @IBOutlet weak var eventImage: UIView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventDayDate: UILabel!
    @IBOutlet weak var eventMonthDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
