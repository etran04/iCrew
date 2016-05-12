//
//  InitialMinistryTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import Foundation

class InitialMinistryTableViewController: UITableViewController {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var popViewController : PopUpViewControllerSwift!
    
    var campusCollection: [CampusData] = []
    var ministryCollection = [[MinistryData]]()
    var savedMinistries = [MinistryData]()
    
    var ministriesCollection = [[Ministry]]() // TODO: Remove
    var selectedIndices: [NSIndexPath] = []
    
    //TODO: Remove
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
        
        campusCollection = UserProfile.getCampuses()
        ministriesCollection = Array(count: campusCollection.count, repeatedValue: [Ministry]())
        ministryCollection = Array(count: campusCollection.count, repeatedValue: [MinistryData]())
        
        DBClient.getData("ministries", dict: setMinistries)
        
        savedMinistries = UserProfile.getMinistries()
        
        self.nextButton.enabled = false
    }
    
    //retreive ministries from the database that belong to the user's campuses
    func setMinistries(ministries:NSArray) {
        //self.tableView.beginUpdates()

        for ministry in ministries {
            print(ministry["name"])
            
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
    
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return campusCollection.count //
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ministriesCollection[section].count //
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
    }
    
    func doNothing() {
        // Does nothing to prevent touching popupview from closing
    }
    
    @IBAction func closePopupViewController(recognizer:UITapGestureRecognizer) {
        self.popViewController.removeAnimate()
    }

    //save selected ministries into the user profile
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UserProfile.removeAllEntities("Ministry")
        
        for index in selectedIndices {
            print(index)
            UserProfile.addMinistry(ministryCollection[index.section][index.row])
        }
        dump(UserProfile.getMinistries())
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return campusCollection[section].name
    }

}
