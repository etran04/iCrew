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
    @IBOutlet weak var rideshareButton: UIButton!
    
    /* Reference to the parent table view controller */
    var tableController : UITableViewController
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        tableController = UITableViewController()
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        tableController = UITableViewController()
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

    @IBAction func ridesharePressed(sender: UIButton) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: eventName.text!, message: "What would you like for the event?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let offerRideAction: UIAlertAction = UIAlertAction(title: "Offer a ride", style: .Default)
            { action -> Void in
                print("offer a ride selected")
//                self.tableController.performSegueWithIdentifier("segue_setup_customer", sender: self)
//                let tabController = self.tableController.tabBarController
//                tabController?.transitionFromViewController(self.tableController, toViewController: DriverQuestionaireVC(), duration: 2, options: UIViewAnimationOptions.CurveEaseIn, animations: nil, completion: nil)
                
        }
        actionSheetController.addAction(offerRideAction)
        
        //Create and add a second option action
        let requestRideAction: UIAlertAction = UIAlertAction(title: "Request a ride", style: .Default)
            { action -> Void in
                print("request a ride selected")

//                self.tableController.performSegueWithIdentifier("segue_setup_provider", sender: self)
                
        }
        actionSheetController.addAction(requestRideAction)
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        //Present the AlertController
        self.tableController.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
}
