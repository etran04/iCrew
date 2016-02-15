//
//  InitialMinistryTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class InitialMinistryTableViewController: UITableViewController {

    
    var popViewController : PopUpViewControllerSwift!
    
    var ministriesCollection = [String]()
    var isSelected: [Bool] = [Bool]()
    var selected: [String] = [String]()
    
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
        
        //pull from database here
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //remove empty separator 
        tableView.tableFooterView = UIView()
        
        //set empty back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        var dbClient: DBClient!
        dbClient = DBClient()
        //”event”, “ministry”, “campus”, etc
        dbClient.getData("ministry", dict: setMinistries)
        
    }
    
    func setMinistries(ministry:NSDictionary) {
        //self.tableView.beginUpdates()
        
        let name = ministry["name"] as! String
    
        ministriesCollection.append(name)
        isSelected.append(false);
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
        return ministriesCollection.count //
    }
    
    // Uncomment
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! InitialMinistryTableViewCell
        
        // Configure the cell...
        
        cell.ministry.text = ministriesCollection[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!

        
        if (!selected.contains(ministriesCollection[indexPath.row])) {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            //cell.contentView.backgroundColor = UIColor(red: CGFloat(98/255.0), green: CGFloat(96/255.0), blue: CGFloat(98/255.0), alpha: CGFloat(0.25) )
            //cell.contentView.superview!.backgroundColor = UIColor(red: CGFloat(98/255.0), green: CGFloat(96/255.0), blue: CGFloat(98/255.0), alpha: CGFloat(0.80) )
            selected.append(ministriesCollection[indexPath.row])
            dump(selected)
            
        }
        else {
            isSelected[indexPath.row] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.contentView.superview!.backgroundColor = UIColor.clearColor()
            selected = selected.filter() {$0 != ministriesCollection[indexPath.row]}
            
            dump(selected)
        }
    }
    

}
