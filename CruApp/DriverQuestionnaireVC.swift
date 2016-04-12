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
import Alamofire
import GoogleMaps
import DatePickerCell


/* This class is used to gather information from a potential driver of the RideShare feature */
class DriverQuestionnaireVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /* constants for setting up datepicker in ideal pickup time */
    let IDEAL_TIME_INTERVAL = 15
    let TIME_FORMAT = "hh:mm a"
    let kDefaultCellHeight = 44

    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var infoTable: UITableView!
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }

    var eventChoices = [String]()
    var eventIds = [String]()
    var eventTime = [String]()
    
    var cells = [AnyObject]()
    var locationChoices = [String]()
    var ministryCollection: [MinistryData] = []
    
    var pickupAdress: GMSPlace?
    var zipcode: String?
    var street: String?
    var city: String?
    var state: String?
    var country: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* sets up the database to pull from */
        DBClient.getData("events", dict: setEvents)

        ministryCollection = UserProfile.getMinistries()
        
    }
    
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        /* prepares fields to be filled for questionaire */
        //initializeScreen()

        // looks for single or multiple taps
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* Helper method to create the cells for the screen */
    func initializeScreen() {
        
        let driveTypeCell = infoTable.dequeueReusableCellWithIdentifier("driveTypeCell") as!DriveTypeCell
        
        /* set up radio buttons */
        driveTypeCell.driveTypes.options = [
            CheckmarkOption(title:"To & From Event \n(Round Trip)"),
            CheckmarkOption(title: "To Event \n(One-way)"),
            CheckmarkOption(title: "From Event \n(One-way)")]
        driveTypeCell.driveTypes.addTarget(self, action: "optionSelected:", forControlEvents: UIControlEvents.ValueChanged)
        
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
        self.locationChoices = self.eventChoices
        
        if (self.locationChoices.count == 0) {
            self.locationChoices.append("No events to select")
        }
        
        locationPickerCell.setChoices(self.locationChoices)
        
        // Sets up Start Time DatePickerCell
        let startPickerCell = StartTimePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        // Sets up the number seats available cell
        let availNumCell = infoTable.dequeueReusableCellWithIdentifier("availSeatCell") as! AvailNumSeatCell
        
        // Sets up the cell for autocomplete location
        let locationCell = infoTable.dequeueReusableCellWithIdentifier("locationCell") as! EnterLocationPlaceCell
        
        // Cells is a cells to be used
        cells = [nameCell!, phoneCell!, locationPickerCell, startPickerCell, availNumCell, driveTypeCell, locationCell]
        
        // Replaces the extra cells at the end with a clear view
        infoTable.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    
    // Obtain event information from the database to an Object
    func setEvents(events: NSArray) {
        
        for event in events {
            var existsInMinistry = false
            
            if (event["parentMinistry"]! == nil) {
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
            let time = event["startDate"] as! String
            self.eventChoices.append(name)
            self.eventIds.append(id)
            self.eventTime.append(time)
            
        }
        initializeScreen()
    }
    
    /* Callback for when a new radio button is clicked */
    func optionSelected(sender: AnyObject) {
        print("DriverQ - Selected option: \((cells[5] as! DriveTypeCell).driveTypes.selectedIndex)")
    }
    
    /* Calls this function when the tap is recognizedd
     * Causes the view (or one of its embedded text fields) to resign the first responder status. */
//    func dismissKeyboard() {
//        infoTable.endEditing(true)
//    }
    
    func parsePhoneNumber(phoneNum : String) -> Int {
        // split by '-'
        let full = phoneNum.componentsSeparatedByString("-")
        let left = full[0]
        let right = full[1]
        
        // get area code from ()
        var index1 = left.startIndex.advancedBy(1)
        let delFirstParen = left.substringFromIndex(index1)
        let index2 = delFirstParen.startIndex.advancedBy(3)
        let areaCode = delFirstParen.substringToIndex(index2)
        
        // get first three digits 
        index1 = left.startIndex.advancedBy(6)
        let threeDigits = left.substringFromIndex(index1)
        
        // get last four digits
        // = right

        let finalPhoneNum = areaCode + threeDigits + right
        return Int(finalPhoneNum)!

    }
    
    @IBAction func submitPressed(sender: UIBarButtonItem) {
        
        /* TO DO: Validate driver information, make sure everything is good to go */
        
        
        // GETTING DATE FROM DATEPICKER
//        print((cells[3] as! DatePickerCell).datePicker.date)
//
//        
        // GETTING EVENT FROM SCROLLPICKER
//        print((cells[2] as! ScrollPickerCell).scrollPicker.selectedRowInComponent(0))
//        print("eventId" + eventIds[(cells[2] as! ScrollPickerCell).scrollPicker.selectedRowInComponent(0)])
        
        //grab questionaire data to add to data
        
        var rideDirection : String
        
        let driveChoices = (cells[5] as! DriveTypeCell).driveTypes.options
        let selectedIdx = (cells[5] as! DriveTypeCell).driveTypes.selectedIndex
        
        if(driveChoices[selectedIdx].title == "To & From Event \n(Round Trip)") {
            rideDirection = "both"
        }
        else if (driveChoices[selectedIdx].title == "To Event \n(One-way)") {
            rideDirection = "to"
        } else {
            rideDirection = "from"
        }

        //TO DO - FIGURE OUT WHICH EVENT IS PICKED, AND GCM
        
        let driverName = (cells[0] as! NameFieldCell).driverFullName.text
        print("number: " + ((cells[1] as! PhoneNumCell).driverPhoneNum.text!))
        let drivePhoneNum = parsePhoneNumber(((cells[1] as! PhoneNumCell).driverPhoneNum.text!))
        let numSeatsChoice = Int((cells[4] as! AvailNumSeatCell).stepper.value)
        
        let location : [String: AnyObject] =
        [
            "postcode": zipcode!,
            "state": state!,
            "street1": street!,
            "suburb": city!,
            "country": country!
        ]
        
        let params : [String: AnyObject] =
        [
            "location": location,
            "direction": rideDirection,
            "seats": numSeatsChoice,
            "driverNumber": drivePhoneNum,
            "event": eventIds[(cells[2] as! ScrollPickerCell).scrollPicker.selectedRowInComponent(0)],
            "driverName": driverName!,
            "time": String((cells[3] as! DatePickerCell).datePicker.date),
            "gcm_id" : 1234567
        ]

        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            DBClient.addData("rides", body : body)
        } catch {
            print("Error sending data to database")
        }
        
        /* Show a visual alert displaying successful signup */
        let successAlert = UIAlertController(title: "Success!", message:
            "Thank you for signing up as a driver!", preferredStyle: UIAlertControllerStyle.Alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
            {
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
    
        self.presentViewController(successAlert, animated: true, completion: nil)
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
            for (var i = 0; i < cells.count; i++) {
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
            for (var i = 0; i < cells.count; i++) {
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

extension DriverQuestionnaireVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        (cells[6] as! EnterLocationPlaceCell).locationLabel.text = place.formattedAddress!
        var components = place.addressComponents
        var streetNumber: String?
        var streetName: String?
        for comp in components! {
            if(comp.type == "street_number") {
                streetNumber = comp.name
            }
            else if(comp.type == "route") {
                streetName = comp.name
            }
            else if(comp.type == "locality") {
                city = comp.name
            }
            else if(comp.type == "administrative_area_level_1") {
                state = comp.name
            }
            else if(comp.type == "country") {
                country = comp.name
            }
            else if(comp.type == "postal_code") {
                zipcode = comp.name
            }
        }
        street = streetNumber! + " " + streetName!
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}