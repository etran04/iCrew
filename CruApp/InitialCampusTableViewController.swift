//
//  InitialCampusTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class InitialCampusTableViewController: UITableViewController {
    
    var popViewController : PopUpViewControllerSwift!

    //var test: [String] = ["Cal Poly", "UCSB"] //
    var campusCollection = [CampusData]()
    var selectedIndices: [Int] = []
    
    @IBAction func clickInfo(sender: AnyObject) {
        
        let bundle = NSBundle(forClass: PopUpViewControllerSwift.self)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: bundle)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
        } else
        {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: bundle)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: bundle)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
                }
            } else {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: bundle)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!UserProfile.isFirstTime()) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("mainRootViewController") as! SWRevealViewController
            self.presentViewController(vc, animated: false, completion: nil)
        }
        else {
            UserProfile.initialUsage()
            
            //set up database
            var dbClient: DBClient!
            dbClient = DBClient()
            dbClient.getData("campus", dict: setCampuses)
            
            //remove extra separators
            self.tableView.tableFooterView = UIView()
            
            //set empty back button
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        }
    }
    
    func setCampuses(campus:NSDictionary) {
        let name = campus["name"] as! String
        let id = campus["_id"] as! String
        
        campusCollection.append(CampusData(name: name, id: id))
        // TODO: Remove campuses Collection and use cache
        self.tableView.reloadData()
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
        return campusCollection.count //
    }
    

    
    // Uncomment
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! InitialCampusTableViewCell

        //set campus text
        cell.campus.text = campusCollection[indexPath.row].name;
    
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if (!selectedIndices.contains(indexPath.row)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedIndices.append(indexPath.row)
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedIndices.removeAtIndex(selectedIndices.indexOf(indexPath.row)!);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        for index in selectedIndices {
            UserProfile.addCampus(campusCollection[index])
        }
    }
}
