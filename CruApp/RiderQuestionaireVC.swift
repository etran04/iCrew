//
//  RiderQuestionaireVC.swift
//  CruApp
//
//  Created by Eric Tran on 1/28/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import DownPicker
import CheckmarkSegmentedControl

/* This class is used to gather information from a potential rider of the RideShare feature */
class RiderQuestionaireVC: UIViewController {

    @IBOutlet weak var passengerNumber: UITextField!
    @IBOutlet weak var passengerFullName: UITextField!
    @IBOutlet weak var driveTypes: CheckmarkSegmentedControl!
    @IBOutlet weak var eventsChoice: UITextField!
    
    var eventDownPicker: DownPicker!
    var eventChoices = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* sets up the database to pull from */
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("event", dict: setEvents)
        
        /* prepares fields to be filled for questionaire */
        initializeChoices()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* looks for single or multiple taps */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Helper method to populate choices for # of seats available */
    func initializeChoices() {
        
        /* set up radio buttons */
        driveTypes.options = [
            CheckmarkOption(title:"To & From Event \n(Round Trip)"),
            CheckmarkOption(title: "To Event \n(One-way)"),
            CheckmarkOption(title: "From Event \n(One-way)")]
        driveTypes.addTarget(self, action: "optionSelected:", forControlEvents: UIControlEvents.ValueChanged)
    }

    /* Callback for when a new radio button is clicked */
    func optionSelected(sender: AnyObject) {
        print("RiderQ - Selected option: \(driveTypes.options[driveTypes.selectedIndex])")
    }
    
    // Obtain event information from the database to an Object
    func setEvents(event: NSDictionary) {
        let name = event["name"] as! String
        self.eventChoices.append(name)
        
        /* populate event choices */
        self.eventDownPicker = DownPicker(textField: self.eventsChoice, withData: eventChoices)
        self.eventDownPicker.setPlaceholder("Choose an event...")
    }
    
    @IBAction func submitPressed(sender: UIButton) {
        
        /* TO DO: Validate driver information, make sure everything is good to go */
        
        //grab questionaire data to add to data
        
        var rideDirection : String
        
        if(driveTypes.options[driveTypes.selectedIndex].title == "To & From Event \n(Round Trip)") {
            rideDirection = "both"
        }
        else if (driveTypes.options[driveTypes.selectedIndex].title == "To Event \n(One-way)") {
            rideDirection = "to"
        } else {
            rideDirection = "from"
        }
        
        //let params = ["direction": rideDirection, "phone": Int(driverPhoneNumber.text!)!, "name": driverFullName.text!, "gcm_id" : 1234567]
        
//        do {
//            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
//            dbClient.addData("ride", body : body)
//        } catch {
//            print("Error sending data to database")
//        }
        
        /* Show a visual alert displaying successful signup */
//        let successAlert = UIAlertController(title: "Success!", message:
//            "Thank you for signing up as a driver!", preferredStyle: UIAlertControllerStyle.Alert)
//        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
//            {
//                (action: UIAlertAction!) -> Void in
//                self.performSegueWithIdentifier("finishQuestionaire", sender: self)
//        }))
//        
//        self.presentViewController(successAlert, animated: true, completion: nil)
    }
    
    
    /* Calls this function when the tap is recognizedd
    * Causes the view (or one of its embedded text fields) to resign the first responder status. */
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
