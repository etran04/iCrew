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
    
    /* Reference to the parent table view controller */
    var tableController : UITableViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        tableController = UITableViewController()
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        tableController = UITableViewController()
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        let tableView = self.superview!.superview as! UITableView
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(buttonPosition)
                
        let myRides = tableController as! RideShareStatusTableViewController
        myRides.cancelDriver(indexPath!.row)
    }
}
