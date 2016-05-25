//
//  InitialMinistryTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import Foundation
import SwiftLoader
import DZNEmptyDataSet
import ReachabilitySwift

class InitialMinistryTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var popViewController : PopUpViewControllerSwift!
    
    var campusCollection: [CampusData] = []
    var ministryCollection = [[MinistryData]]()
    var savedMinistries = [MinistryData]()
    
    var ministriesCollection = [[Ministry]]() // TODO: Remove
    var selectedIndices: [NSIndexPath] = []
    
    struct Ministry {
        var name: String
        var description: String?
        var image: String?
        //var campus: String?
        
        init(name: String, description: String?, image: String?)
        {
            self.name = name
            self.description = description
            self.image = image
            //self.campus = campus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove empty separator 
        tableView.tableFooterView = UIView()
        
        //set empty back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        checkInternet()
        
        self.nextButton.enabled = false
    }
    
    //save selected ministries into the user profile
    override func viewWillDisappear(animated: Bool) {
        UserProfile.removeAllEntities("Ministry")
        
        for index in selectedIndices {
            print(index)
            UserProfile.addMinistry(ministryCollection[index.section][index.row])
        }
    }
    
    @IBAction func pressedNext(sender: AnyObject) {
        print(selectedIndices.count == 0)
    }

    /* Determines whether or not the device is connected to WiFi or 4g. Alerts user if they are not.
     * Without internet, data might not populate, aside from cached data */
    func checkInternet() {
        
        // Checks for internet connectivity (Wifi/4G)
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        SwiftLoader.show(title: "Loading...", animated: true)
        
        // If device does have internet
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
                self.campusCollection = UserProfile.getCampuses()
                self.ministriesCollection = Array(count: self.campusCollection.count, repeatedValue: [Ministry]())
                self.ministryCollection = Array(count: self.campusCollection.count, repeatedValue: [MinistryData]())
                
                DBClient.getData("ministries", dict: self.setMinistries)
                
                self.savedMinistries = UserProfile.getMinistries()
            }
        }
        
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                
                // If unreachable, hide the loading indicator anyways
                SwiftLoader.hide()
                
                // If no internet, display an alert notifying user they have no internet connectivity
                let g_alert = UIAlertController(title: "Checking for Internet...", message: "If this dialog appears, please check to make sure you have internet connectivity. ", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // Dismiss alert dialog
                    print("Dismissed No Internet Dialog")
                }
                g_alert.addAction(OKAction)
                
                // Sets up the controller to display notification screen if no events populate
                self.tableView.emptyDataSetSource = self;
                self.tableView.emptyDataSetDelegate = self;
                self.tableView.reloadEmptyDataSet()
                
                self.presentViewController(g_alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    //retreive ministries from the database that belong to the user's campuses
    func setMinistries(ministries:NSArray) {
        for ministry in ministries {
            let campus = ministry["campuses"] as! [String]
        
            //check if campus is empty
            if (campus.first != nil) {
                let campusId = campus.first! as String
                
                //if ministry belongs to one of the user's campuses, add it to the 
                //ministry collection
                for (index,_) in campusCollection.enumerate() {
                    if (campusCollection[index].id == campusId) {
                        let name = ministry["name"] as! String
                        let id = ministry["_id"] as! String
                        let description = ministry["description"] as! String!
                        let image = ministry["image"]??.objectForKey("secure_url") as! String!
                        //let campus = ministry["campuses"] as! String
                
                        let ministryObj = Ministry(name: name, description: description, image: image)
                        let ministryDataObj = MinistryData(name: name, id: id, campusId: campusId)
                
                        ministriesCollection[index].append(ministryObj)
                        ministryCollection[index].append(ministryDataObj)
                    }
                }
            }
        }
        SwiftLoader.hide()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return campusCollection.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ministriesCollection[section].count
    }
    
    // Configure table view cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! InitialMinistryTableViewCell
        let ministry = ministriesCollection[indexPath.section][indexPath.row]
        
        // Configure the cell...
        cell.ministry.text = ministry.name
        
        //set info button with the cells row and section
        cell.infoButton.section = indexPath.section
        cell.infoButton.row = indexPath.row
        
        //check if the ministry has already been saved to the user
        var isSaved = false
        for ministry in savedMinistries {
            if ministry.name == cell.ministry.text {
                isSaved = true
                break
            }
        }
        
        if (isSaved) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.nextButton.enabled = true
            selectedIndices.append(indexPath)
        }
        
        return cell
    }
    
    //actions when a row is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        UserProfile.addMinistry(ministryCollection[indexPath.section][indexPath.row])
        
        if (!selectedIndices.contains(indexPath)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedIndices.append(indexPath)
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedIndices.removeAtIndex(selectedIndices.indexOf(indexPath)!)
        }
        nextButton.enabled = selectedIndices.count > 0
    }
    
    //outside library method
    //show more info of the ministry when selected
    @IBAction func clickInfo(sender: AnyObject) {
        let ministry = ministriesCollection[sender.section][sender.row]
        
        var image = UIImage(named: "Cru-Logo.png")
        
        if(ministry.image != nil) {
            let url = NSURL(string: ministry.image!)
            let data = NSData(contentsOfURL: url!)
            image = UIImage(data: data!)
        }

        
        let bundle = NSBundle(forClass: PopUpViewControllerSwift.self)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: bundle)
            self.popViewController.showInView(self.view, withImage: image, withMessage: ministry.description, animated: true)
        }
        else {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: bundle)
                    self.popViewController.showInView(self.view, withImage: image, withMessage: ministry.description, animated: true)
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: bundle)
                    self.popViewController.showInView(self.view, withImage: image, withMessage: ministry.description, animated: true)
                }
            } else {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: bundle)
                self.popViewController.showInView(self.view, withImage: image, withMessage: ministry.description, animated: true)
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(InitialMinistryTableViewController.closePopupViewController(_:)))
        let ignoreTap = UITapGestureRecognizer(target: self,
                                             action: #selector(InitialMinistryTableViewController.doNothing))
        self.view.addGestureRecognizer(tapRecognizer)
        self.popViewController.popUpView.addGestureRecognizer(ignoreTap)
        self.tableView.scrollEnabled = false
    }
    
    func doNothing() {
        // Does nothing to prevent touching popupview from closing
    }
    
    @IBAction func closePopupViewController(recognizer:UITapGestureRecognizer) {
        self.popViewController.removeAnimate()
        self.view.removeGestureRecognizer(recognizer)
        self.tableView.scrollEnabled = true
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return campusCollection[section].name
    }
    
    // MARK: - DZNEmptySet Delegate/DataSource methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No ministries to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check your internet."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Click to refresh!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        checkInternet()
    }

}
