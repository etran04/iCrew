//
//  SelectDriverTableViewCell.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class SelectDriverTableViewCell: UITableViewCell {

    @IBOutlet weak var driverNumber: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var depatureTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    
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

    @IBAction func viewMapPressed(sender: UIButton) {
        let tableView = self.superview!.superview as! UITableView
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(buttonPosition)
        
        let selectRides = tableController as! SelectDriverTableViewController
        selectRides.showMap(indexPath!.row)
    }

}
