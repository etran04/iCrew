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

    
    var popViewController : PopUpViewControllerSwift!
    
    var campusCollection: [CampusData] = []
    var ministriesCollection = [Ministry]()
    var isSelected: [Bool] = [Bool]()
    var selected: [String] = [String]()
    
    struct Ministry{
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
        
        var dbClient: DBClient!
        dbClient = DBClient()
        //”event”, “ministry”, “campus”, etc
        dbClient.getData("ministry", dict: setMinistries)
        
    }
    
    func setMinistries(ministry:NSDictionary) {
        //self.tableView.beginUpdates()
        
        let campus = ministry["campuses"] as! [String]
        
        if (campus.first == nil) {
            return;
        }
        
        let campusId = campus.first! as String
        var existsInCampus = false
        
        for campusObj in campusCollection {
            if (campusObj.id == campusId) {
                existsInCampus = true;
            }
        }
        
        if (existsInCampus) {
            let name = ministry["name"] as! String
            let description = ministry["description"] as! String!
            let image = ministry["image"]?.objectForKey("secure_url") as! String!
            //let campus = ministry["campuses"] as! String
        
            let ministryObj = Ministry(name: name, description: description, image: image)
        
            ministriesCollection.append(ministryObj)
            isSelected.append(false);
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ministriesCollection.count //
    }
    
    // Uncomment
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! InitialMinistryTableViewCell
        let ministry = ministriesCollection[indexPath.row]
        
        // Configure the cell...
        
        cell.ministry.text = ministry.name
        cell.infoButton.tag = indexPath.row
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if (!selected.contains(ministriesCollection[indexPath.row].name)) {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selected.append(ministriesCollection[indexPath.row].name)
            dump(selected)
            
        }
        else {
            isSelected[indexPath.row] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            selected = selected.filter() {$0 != ministriesCollection[indexPath.row].name}
            
            dump(selected)
        }
    }
    
    @IBAction func clickInfo(sender: AnyObject) {
        let ministry = ministriesCollection[sender.tag]
        
        var image = UIImage(named: "Cru-Logo.png")
        
        if(ministry.image != nil) {
            let url = NSURL(string: ministry.image!)
            let data = NSData(contentsOfURL: url!)
            image = UIImage(data: data!)
        }

        
        let bundle = NSBundle(forClass: PopUpViewControllerSwift.self)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: bundle)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: image, withMessage: ministriesCollection[sender.tag].description, animated: true)
        } else
        {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: bundle)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: image, withMessage: ministriesCollection[sender.tag].description, animated: true)
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: bundle)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: image, withMessage: ministriesCollection[sender.tag].description, animated: true)
                }
            } else {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: bundle)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: image, withMessage: ministriesCollection[sender.tag].description, animated: true)
            }
        }
        
        
    }

    

}
