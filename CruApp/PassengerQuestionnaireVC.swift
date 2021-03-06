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
import DatePickerCell

/* This class is used to gather information from a potential rider of the RideShare feature */
class PassengerQuestionnaireVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var passenger: Passenger!
    var eventChoices = [String]()
    var eventIds = [String]()
    
    var cells = [AnyObject]()
    var ministryCollection: [MinistryData] = []

    let kDefaultCellHeight = 44

    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var infoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        /* sets up the database to pull from */
        DBClient.getData("events", dict: setEvents)
        
        ministryCollection = UserProfile.getMinistries()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /* prepares fields to be filled for questionaire */
        //initializeChoices()


        /* looks for single or multiple taps */
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Helper method to populate choices for # of seats available */
    func initializeChoices() {
        
        let driveTypeCell = infoTable.dequeueReusableCellWithIdentifier("driveTypeCell") as!DriveTypeCell
        
        /* set up radio buttons */
        driveTypeCell.driveTypes2.options = [
            CheckmarkOption(title:"To & From Event \n(Round Trip)"),
            CheckmarkOption(title: "To Event \n(One-way)"),
            CheckmarkOption(title: "From Event \n(One-way)")]
        driveTypeCell.driveTypes2.addTarget(self, action: #selector(PassengerQuestionnaireVC.optionSelected(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.rowHeight = UITableViewAutomaticDimension
        infoTable.estimatedRowHeight = CGFloat(kDefaultCellHeight)
        
        // Sets up name cell
        let nameCell = infoTable.dequeueReusableCellWithIdentifier("nameCell") as UITableViewCell?
        
        // Set up phone number cell
        let phoneCell = infoTable.dequeueReusableCellWithIdentifier("phoneNumCell") as UITableViewCell?
        
        // Sets up scroll picker cell for locations
        let locationPickerCell = ScrollPickerCell(style: .Default, reuseIdentifier: nil)
        if (self.eventChoices.count == 0) {
            self.eventChoices.append("No events to select")
        }
        locationPickerCell.setChoices(self.eventChoices)
        
        // Sets up Start Time DatePickerCell
        let startPickerCell = StartTimePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        // Cells is a cells to be used
        cells = [nameCell!, phoneCell!, locationPickerCell, startPickerCell, driveTypeCell]
        
        // Replaces the extra cells at the end with a clear view
        infoTable.tableFooterView = UIView(frame: CGRect.zero)
        
    }

    /* Callback for when a new radio button is clicked */
    func optionSelected(sender: AnyObject) {
        print("DriverQ - Selected option: \((cells[4] as! DriveTypeCell).driveTypes2.selectedIndex)")
    }
    
    
    // Obtain event information from the database to an Object
    func setEvents(events: NSArray) {
        
        for event in events {
            var existsInMinistry = false
            
            if(event["parentMinistry"]! == nil && event["parentMinistries"]! == nil) {
                let parentMinistries = event["ministries"] as! [String]
                
                for ministryId in parentMinistries {
                    for ministry in ministryCollection {
                        if (ministryId == ministry.id) {
                            existsInMinistry = true;
                        }
                    }
                }
                
            }
            else if (event["parentMinistry"]! == nil) {
                let parentMinistries = event["parentMinistries"] as! [String]
                
                for ministryId in parentMinistries {
                    for ministry in ministryCollection {
                        if (ministryId == ministry.id) {
                            existsInMinistry = true;
                        }
                    }
                }
            }
            else {
                let ministryId = event["parentMinistry"] as! String
                
                for ministry in ministryCollection {
                    if (ministry.id == ministryId) {
                        existsInMinistry = true;
                    }
                }
            }
            
            if (!existsInMinistry) {
                continue
            }
        
            let name = event["name"] as! String
            let id = event["_id"] as! String
            self.eventChoices.append(name)
            self.eventIds.append(id)
        }
        /* prepares fields to be filled for questionaire */
        initializeChoices()
    }
    
    
    /* Calls this function when the tap is recognizedd
    * Causes the view (or one of its embedded text fields) to resign the first responder status. */
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var rideDirection : String
        
        let driveChoices = (cells[4] as! DriveTypeCell).driveTypes2.options
        let selectedIdx = (cells[4] as! DriveTypeCell).driveTypes2.selectedIndex
        
        if(driveChoices[selectedIdx].title == "To & From Event \n(Round Trip)") {
            rideDirection = "both"
        }
        else if (driveChoices[selectedIdx].title == "To Event \n(One-way)") {
            rideDirection = "to"
        } else {
            rideDirection = "from"
        }
        
        let riderName = (cells[0] as! NameFieldCell).riderFullName.text
        
        var riderPhoneNum = ""
        if(!((cells[1] as! PhoneNumCell).riderPhoneNum.text!).isEmpty) {
            riderPhoneNum = Utils.parsePhoneNumber(((cells[1] as! PhoneNumCell).riderPhoneNum.text!))
        }
        
        //print("Time: " + String((cells[3] as! DatePickerCell).datePicker.date))
        let time = String((cells[3] as! DatePickerCell).datePicker.date)
        let timeString = (cells[3] as! DatePickerCell).rightLabel.text

        let event = eventIds[(cells[2] as! ScrollPickerCell).scrollPicker.selectedRowInComponent(0)]
        let eventName = (cells[2] as! ScrollPickerCell).rightLabel.text

        if(riderPhoneNum.isEmpty || riderName!.isEmpty || eventName == "Choose an event" || timeString == "Choose the ideal time") {
            let alertController = UIAlertController(title: "ERROR", message:
                "Please fill out form before submitting.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler:nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
        
            print("Time: " + String((cells[3] as! DatePickerCell).datePicker.date))
        
            passenger = Passenger(
                name: riderName!,
                eventId: event,
                phoneNumber: riderPhoneNum,
                direction: rideDirection,
                departureTime: time,
                gcmId: gcm_id!)
        
            let selectDriverViewController = segue.destinationViewController as! SelectDriverTableViewController
            selectDriverViewController.passenger = passenger
        
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
        
    }
    
    func verifyAllFields() -> Bool {
        let timeString = (cells[3] as! DatePickerCell).rightLabel.text
    
        let eventName = (cells[2] as! ScrollPickerCell).rightLabel.text
    
        if(eventName == "Choose an event" || timeString == "Choose the ideal time") {
            print("FALSEE!")
            return false
        }
        return true
    }
    
    /* Returns height of row in tableview */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DatePickerCell)) {
            return (cell as! DatePickerCell).datePickerHeight()
        }
        else if (cell.isKindOfClass(ScrollPickerCell)) {
            return (cell as! ScrollPickerCell).datePickerHeight()
        }
        else if (cell.isKindOfClass(DriveTypeCell)) {
            return CGFloat(110)
        }
        
        return CGFloat(kDefaultCellHeight)
    }
    
    /* Callback for when cell is selected */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DatePickerCell)) {
            let pickerTableViewCell = cell as! DatePickerCell
            pickerTableViewCell.selectedInTableView(tableView)
            self.infoTable.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Collapses all other cells
            for (var i = 0; i < cells.count; i += 1) {
                if (cells[i].isKindOfClass(ScrollPickerCell)) {
                    if (i != indexPath.row && cells[i].expanded == true) {
                        (cells[i] as! ScrollPickerCell).selectedInTableView(tableView)
                    }
                }
                else if (cells[i].isKindOfClass(DatePickerCell)) {
                    if (i != indexPath.row && cells[i].expanded == true) {
                        (cells[i] as! DatePickerCell).selectedInTableView(tableView)
                    }
                }
            }
        }
        else if (cell.isKindOfClass(ScrollPickerCell)) {
            let pickerTableViewCell = cell as! ScrollPickerCell
            pickerTableViewCell.selectedInTableView(tableView)
            self.infoTable.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Collapses all other cells
            for (var i = 0; i < cells.count; i += 1) {
                if (cells[i].isKindOfClass(ScrollPickerCell)) {
                    if (i != indexPath.row && cells[i].expanded == true) {
                        (cells[i] as! ScrollPickerCell).selectedInTableView(tableView)
                    }
                }
                else if (cells[i].isKindOfClass(DatePickerCell)) {
                    if (i != indexPath.row && cells[i].expanded == true) {
                        (cells[i] as! DatePickerCell).selectedInTableView(tableView)
                    }
                }
            }
        }
        
        self.submitButton.enabled = self.verifyAllFields();
    }
    
    /* Called to determine number of sections in tableView */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* Called to determine number of rows in tableView */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    /* Configures each cell in tableView */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row] as! UITableViewCell
    }

}
