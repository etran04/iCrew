//
//  SidebarTableViewController.swift
//  CruApp
//
//  Created by Daniel Lee on 2/17/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class SidebarTableViewController: UITableViewController {

    @IBOutlet weak var loginCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //self.tableView.tableHeaderView = nil;
        //let headerFrame = CGRect(self.tableView.tableHeaderView.frame)
        //headerFrame.size.height      = self.myStatus.frame.size.height + offset;
        //self.header.frame            = headerFrame;
        //self.profile.tableHeaderView = self.header;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)
        
        if (indexPath.row == 0) {
            let vc = storyboard.instantiateViewControllerWithIdentifier("ministryViewController") as! UITableViewController
            let navController = storyboard.instantiateViewControllerWithIdentifier("initialNavController") as! UINavigationController
            navController.showViewController(vc, sender: navController)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else if (indexPath.row == 1) {
            let navController = storyboard.instantiateViewControllerWithIdentifier("initialNavController") as! UINavigationController
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else {
            // Login!
            loginView()
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         print("got here123")
    }
    
    /*override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.te
        

        
        return view
    }*/
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func loginView()
    {
        let loginController = UIAlertController(title: "Please Sign In", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        //read in username and password
        let loginAction = UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
            let loginTextField = loginController.textFields![0] as! UITextField
            
            let passwordTextField = loginController.textFields![1] as! UITextField
            
            
        }
        
        //setup login view button options
        loginAction.enabled = false
    
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: UIAlertActionStyle.Destructive, handler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        //configure login controller
        loginController.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
            textField.placeholder = "Username or Email"
            
            textField.keyboardType = UIKeyboardType.EmailAddress
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
                
                let textField = notification.object as! UITextField
                
                loginAction.enabled = !textField.text!.isEmpty
                
            })
            
        }
        
        loginController.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
            textField.placeholder = "Password"
            
            textField.secureTextEntry = true
            
        }
        // 6
        loginController.addAction(loginAction)
        loginController.addAction(forgotPasswordAction)
        loginController.addAction(cancelAction)
        // 7
        presentViewController(loginController, animated: true, completion: nil)

    }

}
