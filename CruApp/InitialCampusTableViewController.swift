//
//  InitialCampusTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class InitialCampusTableViewController: UITableViewController {

    var test: [String] = ["Cal Poly", "UCSB"] //
    var isSelected: [Bool] = [false, false]
    var selected: [String] = []
    
    @IBAction func info(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Cal Poly", message: "Yo this is Cal Poly", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pull from database here
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return test.count //
    }
    
    // Uncomment
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! InitialCampusTableViewCell
        
        // Configure the cell...
        
        cell.campus.text = test[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if (!selected.contains(test[indexPath.row])) {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selected.append(test[indexPath.row])
            dump(selected)
            
        }
        else {
            isSelected[indexPath.row] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            selected = selected.filter() {$0 != test[indexPath.row]}
            
            dump(selected)
        }
    }


}
