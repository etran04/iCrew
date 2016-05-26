//
//  ResourcesViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

/* ResourcesVC is the main branch, leading into the different
 * possible resources, such as Videos, Articles, and Tools */ 
class ResourcesViewController: UITableViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet var cells: [UITableViewCell]!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    var rowSizes: [Int: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.revealViewController().delegate = self
        
        cardsSetup()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //reveal controller function for disabling the current view
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        if position == FrontViewPosition.Left {
            self.tableView.scrollEnabled = true
            
            for view in self.tableView.subviews {
                view.userInteractionEnabled = true
            }
            self.tabBarController?.tabBar.userInteractionEnabled = true
        }
        else if position == FrontViewPosition.Right {
            self.tableView.scrollEnabled = false
            
            for view in self.tableView.subviews {
                view.userInteractionEnabled = false
            }
            self.tabBarController?.tabBar.userInteractionEnabled = false
        }
    }
    
    func cardsSetup() {
        for cell in cells {
            cell.viewWithTag(0)?.alpha = 1;
            cell.viewWithTag(0)?.layer.masksToBounds = false;
            cell.viewWithTag(0)?.layer.cornerRadius = 1;
            cell.viewWithTag(0)?.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
            cell.viewWithTag(0)?.layer.shadowRadius = 5;
        }
    }
    
    @IBAction func text(sender: UIButton) {
        // print("texting...")
        //        let twilioUsername = "ACc18e4b9385be579bdb48ca5526414403"
        //        let twilioPassword = "c5e0f0de4c90c803595851a7554c9a98"
        //
        //        let data = [
        //            "To" : "+17078038796",
        //            "From" : "+17074193527",
        //            "Body" : "It works!"
        //        ]
        //
        //        Alamofire.request(.POST, "https://\(twilioUsername):\(twilioPassword)@api.twilio.com/2010-04-01/Accounts/\(twilioUsername)/Messages", parameters: data)
        //            .responseData { response in
        //                print(response.request)
        //                print(response.response)
        //                print(response.result)
        //        }
        
        let localNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS 8"
        localNotification.alertBody = "Eric is a poop in butt"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "invite"
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}
