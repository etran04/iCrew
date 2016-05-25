//
//  RideshareMainVC.swift
//  CruApp
//
//  Created by Eric Tran on 5/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class RideshareMainVC: UIViewController {

    @IBOutlet weak var swiftPagesView: SwiftPages!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let VCIDs : [String] = ["OfferedVC", "RequestedVC"]
        let buttonTitles : [String] = ["Offered Rides", "Requested Rides"]
        
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)

    }
    
    override func viewDidAppear(animated: Bool) {
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose an option", message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let offerRideAction: UIAlertAction = UIAlertAction(title: "Offer a ride", style: .Default)
        { action -> Void in
            self.performSegueWithIdentifier("toDriverQ", sender: self)
        }
        actionSheetController.addAction(offerRideAction)
        
        //Create and add a second option action
        let requestRideAction: UIAlertAction = UIAlertAction(title: "Request a ride", style: .Default)
        { action -> Void in
            self.performSegueWithIdentifier("toRiderQ", sender: self)
            
        }
        actionSheetController.addAction(requestRideAction)
        
        //We need to provide a popover sourceView when using it on iPad
        //            actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    

}
