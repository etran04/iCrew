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
    private var userCollection = [User]()
    
    //User object for emails and password
    struct User
    {
        var email: String?
        var password: String?
        
        init(email: String?, password: String?)
        {
            self.email = email
            self.password = password
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)
        let navController = storyboard.instantiateViewControllerWithIdentifier("initialNavController") as! UINavigationController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //go to select ministry screen
        if (indexPath.row == 0) {
            let vc = storyboard.instantiateViewControllerWithIdentifier("ministryViewController") as! UITableViewController
            
            navController.showViewController(vc, sender: navController)
            appDelegate.window?.rootViewController = navController;
        }
        //go to select campus screen
        else if (indexPath.row == 1) {
            appDelegate.window?.rootViewController = navController;
        }
        //go to login screen
        else {
            //setup database
            var dbClient: DBClient!
            dbClient = DBClient()
            dbClient.getData("user", dict: setUsers)
            
            //display login pop up
            self.loginView()
        }
    }
    
    //create a collection of users
    func setUsers(users:NSArray) {
        for user in users{
        
            //only create a user if the user's password is not nil
            if let password = user["password"]
            {
                let email = user["email"] as! String
                let userObj = User(email: email, password: password as? String)
                userCollection.append(userObj)
            }
        
            //for testing use
            for(var i = 0; i < userCollection.count; i++)
            {
                print("\(userCollection[i].email) : \(userCollection[i].password)")
            }
        }
    }
    
    
    //create the login pop up
    func loginView()
    {
        let loginController = UIAlertController(title: "Enter Email and Password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        //read in username and password
        let loginAction = UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
            let loginTextField = loginController.textFields![0] as UITextField
            let passwordTextField = loginController.textFields![1] as UITextField
            
            //determine if login info is invalid or nah
            if(!self.isValid(loginTextField.text!, password: passwordTextField.text!)) {
                let message = "Invalid Login"
                loginController.title = message
                self.presentViewController(loginController, animated: true, completion: nil)
            }
            else
            {
                let successAlert = UIAlertController(title: "Success!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                successAlert.addAction(okAction)
                self.presentViewController(successAlert, animated: true, completion: nil)
            }
        }
        loginAction.enabled = false

        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: UIAlertActionStyle.Destructive) { (action:UIAlertAction) -> Void in
            
            let forgotPasswordAlert = UIAlertController(title: "Contact CRU Admin", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
            forgotPasswordAlert.addAction(okAction)
            self.presentViewController(forgotPasswordAlert, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        //configure text fields
        loginController.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
            textField.placeholder = "Email"
            
            textField.keyboardType = UIKeyboardType.EmailAddress
            
            //listener for non empty tet fields
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
                
                let textField = notification.object as! UITextField
                loginAction.enabled = !textField.text!.isEmpty
                
            })
            
        }
        
        loginController.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
        }
        
        
        loginController.addAction(loginAction)
        loginController.addAction(forgotPasswordAction)
        loginController.addAction(cancelAction)
        
        self.presentViewController(loginController, animated: true, completion: nil)
    }
    
    //check if the login is valid
    func isValid(login: String, password: String) -> Bool
    {
        let ndx = userCollection.indexOf({$0.email == login})
        
        if(ndx != nil && userCollection[ndx!].password == password)
        {
            return true
        }
        else
        {
            return false
        }
        
        
    }

    


}
