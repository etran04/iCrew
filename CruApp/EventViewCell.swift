//
//  EventViewCell.swift
//  CruApp
//
//  Created by Tammy Kong on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet weak var eventImage: UIView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventDayDate: UILabel!
    @IBOutlet weak var eventMonthDate: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.cardSetup();
    }
    
    func cardSetup() {
        self.cardView.alpha = 1;
        self.cardView.layer.masksToBounds = false;
        self.cardView.layer.cornerRadius = 1;
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.cardView.layer.shadowRadius = 5;
        //let path = UIBezierPath(rect: self.cardView.bounds)
        //self.cardView.layer.shadowPath = path.CGPath;
        //self.cardView.layer.shadowOpacity = 0.2;
        
    }
}
