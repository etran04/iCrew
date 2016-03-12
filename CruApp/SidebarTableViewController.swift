//
//  SidebarTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 2/17/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class SidebarTableViewController: UITableViewController {

    let numSections = 1
    let numRows = 3
    let loginTitle = "Log In"
    let invalidLoginMsg = "Invalid Login"
    let successMsg = "Success!"
    let okButtonLabel = "OK"
    let cancelButtonLabel = "Cancel"
    let emailInputPlaceholder = "Email"
    let passwordInputPlaceholder = "Password"
    
    
    @IBOutlet weak var loginCell: UITableViewCell!
    private var userCollection = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numRows
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
//TO DO: set height for header
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60.0
//    }
    
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
            if user["password"] != nil
            {
                let userObj = UserData(user: user)
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
        
        let loginController = UIAlertController(title: self.loginTitle, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        //both need to be false to enable login button
        var isEmailEmpty = true
        var isPasswordEmpty = true
        
        //read in username and password
        let loginAction = UIAlertAction(title: self.loginTitle, style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
            let emailTextField = loginController.textFields![0] as UITextField
            let passwordTextField = loginController.textFields![1] as UITextField
            
            //determine if login info is invalid or nah
            if(!self.isValid(emailTextField.text!, password: passwordTextField.text!)) {
                let message = self.invalidLoginMsg
                loginController.title = message
                self.presentViewController(loginController, animated: true, completion: nil)
            }
            else {
                let successAlert = UIAlertController(title: self.successMsg, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: self.okButtonLabel, style: UIAlertActionStyle.Default, handler: nil)
                
                successAlert.addAction(okAction)
                self.presentViewController(successAlert, animated: true, completion: nil)
            }
        }
        loginAction.enabled = false
        
        let cancelAction = UIAlertAction(title: self.cancelButtonLabel, style: UIAlertActionStyle.Cancel, handler: nil)
        
        //configure the email text field with its label, keyboard type, and empty listener
        loginController.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
            textField.placeholder = self.emailInputPlaceholder
            textField.keyboardType = UIKeyboardType.EmailAddress
            
            //listener for non empty text fields
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
                
                let textField = notification.object as! UITextField
                isEmailEmpty = textField.text!.isEmpty
                loginAction.enabled =  !isEmailEmpty && !isPasswordEmpty
                
            })
            
        }
        
        //configure the password text field with its label, password protection, and empty listener
        loginController.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
            textField.placeholder = self.passwordInputPlaceholder
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
                
                let textField = notification.object as! UITextField
                isPasswordEmpty = textField.text!.isEmpty
                loginAction.enabled =  !isEmailEmpty && !isPasswordEmpty
                
            })
        }
        
        loginController.addAction(loginAction)
        loginController.addAction(cancelAction)
        
        self.presentViewController(loginController, animated: true, completion: nil)
    }
    
    //TO DO: use correct database method to validate login
    //check if the login is valid
    func isValid(login: String, password: String) -> Bool
    {
        let ndx = userCollection.indexOf({$0.email == login})
        return ndx != nil && userCollection[ndx!].password == password
    }

    


}
