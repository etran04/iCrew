//
//  DriverQuestionaireVC.swift
//  CruApp
//
//  Created by Eric Tran on 1/28/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import DownPicker
import CheckmarkSegmentedControl

/* This class is used to gather information from a potential driver of the RideShare feature */
class DriverQuestionaireVC: UIViewController {

    /* constants for setting up datepicker in ideal pickup time */
    let IDEAL_TIME_INTERVAL = 15
    let TIME_FORMAT = "hh:mm a"
    
    @IBOutlet weak var eventsChoice: UITextField!
    @IBOutlet weak var numSeatsAvailChoice: UITextField!
    @IBOutlet weak var depatureTimeChoice: UITextField!
    @IBOutlet weak var driveTypes: CheckmarkSegmentedControl!
    
    var eventDownPicker: DownPicker!
    var seatDownPicker: DownPicker!
    var datePickerView  : UIDatePicker!
    
    var eventChoices = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* sets up the database to pull from */
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("event", dict: setEvents)
    }
    
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
        /* prepares fields to be filled for questionaire */
        initializeChoices()
        
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
        
        /* populate event choices */
        self.eventDownPicker = DownPicker(textField: self.eventsChoice, withData: eventChoices)
        self.eventDownPicker.setPlaceholder("Choose an event...")
        
        /* populate seat choices */
        let seatChoices = ([Int](1...10)).map(
            {
                (number: Int) -> String in
                return String(number)
        })
        self.seatDownPicker = DownPicker(textField: self.numSeatsAvailChoice, withData: seatChoices)
    }
    
    // Obtain event information from the database to an Object
    func setEvents(event: NSDictionary) {
        let name = event["name"] as! String
        self.eventChoices.append(name)
    }
    
    /* Callback for when a new radio button is clicked */
    func optionSelected(sender: AnyObject) {
        print("DriverQ - Selected option: \(driveTypes.options[driveTypes.selectedIndex])")
    }
    
    /* Callback when ideal depature time is clicked */
    @IBAction func idealTimeClicked(sender: UITextField) {
        // Brings up a new datepicker
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.minuteInterval = IDEAL_TIME_INTERVAL;
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /* Fills in text field of ideal depature time */
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = TIME_FORMAT;
        depatureTimeChoice.text = dateFormatter.stringFromDate(sender.date)
    }
    
    /* Calls this function when the tap is recognizedd
     * Causes the view (or one of its embedded text fields) to resign the first responder status. */
    func dismissKeyboard() {
        // sets depature time before dismissing
        if datePickerView != nil {
            handleDatePicker(datePickerView)
        }
        view.endEditing(true)
    }
    
    /* Callback for when submit button is pressed */
    @IBAction func submitPressed(sender: UIButton) {
        
        /* TO DO: Validate driver information, make sure everything is good to go */
        
        /* Show a visual alert displaying successful signup */
        let successAlert = UIAlertController(title: "Success!", message:
            "Thank you for signing up as a driver!", preferredStyle: UIAlertControllerStyle.Alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
            {
                (action: UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("finishQuestionaire", sender: self)
            }))
    
        self.presentViewController(successAlert, animated: true, completion: nil)
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
