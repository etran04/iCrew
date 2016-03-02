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
    
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var driveTypes: CheckmarkSegmentedControl!
    @IBOutlet weak var infoTable: UITableView!
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    var dbClient: DBClient!

    var eventChoices = [String]()
    var eventIds = [String]()
    var eventTime = [String]()
    
    var cells = [AnyObject]()
    var locationChoices = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* sets up the database to pull from */
        dbClient = DBClient()
        dbClient.getData("event", dict: setEvents)
        
        /* prepares fields to be filled for questionaire */
        initializeChoices()

        /* sets up the tableview */
        setUpTableView()
    }
    
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        
//        /* looks for single or multiple taps */
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
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

        /* populate seat choices */
        let seatChoices = ([Int](1...10)).map(
            {
                (number: Int) -> String in
                return String(number)
        })
        
    }
    
    /* Helper function for initializing tableview to allow for collapsible datepickercell */
    func setUpTableView() {
        
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
        self.locationChoices = ["The Avenue", "VG Cafe", "Campus Market", "Village Market", "19 Metro Station", "Sandwich Factory"]
        locationPickerCell.setChoices(self.locationChoices)
        
        // Sets up the number seats available cell 
        let availNumCell = infoTable.dequeueReusableCellWithIdentifier("availSeatCell") as! AvailNumSeatCell
        
        // Sets up Start Time DatePickerCell
        let startPickerCell = StartTimePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        // Cells is a cells to be used
        cells = [nameCell!, phoneCell!, locationPickerCell, availNumCell, startPickerCell]
        
        // Replaces the extra cells at the end with a clear view
        infoTable.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    
    // Obtain event information from the database to an Object
    func setEvents(event: NSDictionary) {
        let name = event["name"] as! String
        let id = event["_id"] as! String
        let time = event["startDate"] as! String
        self.eventChoices.append(name)
        self.eventIds.append(id)
        self.eventTime.append(time)
        
//        /* populate event choices */
//        self.eventDownPicker = DownPicker(textField: self.eventsChoice, withData: eventChoices)
//        self.eventDownPicker.setPlaceholder("Choose an event...")
    }
    
    /* Callback for when a new radio button is clicked */
    func optionSelected(sender: AnyObject) {
        print("DriverQ - Selected option: \(driveTypes.options[driveTypes.selectedIndex])")
    }
    
//    /* Callback when ideal depature time is clicked */
//    @IBAction func idealTimeClicked(sender: UITextField) {
//        // Brings up a new datepicker
//        datePickerView = UIDatePicker()
//        datePickerView.datePickerMode = UIDatePickerMode.Time
//        datePickerView.minuteInterval = IDEAL_TIME_INTERVAL;
//        sender.inputView = datePickerView
//        
//        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.TouchUpInside)
//    }
    
//    /* Fills in text field of ideal depature time */
//    func handleDatePicker(sender: UIDatePicker) {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = TIME_FORMAT;
//        depatureTimeChoice.text = dateFormatter.stringFromDate(sender.date)
//        print(depatureTimeChoice.text)
//    }
    
    /* Calls this function when the tap is recognizedd
     * Causes the view (or one of its embedded text fields) to resign the first responder status. */
//    func dismissKeyboard() {
//        // sets depature time before dismissing
//        if datePickerView != nil {
//            handleDatePicker(datePickerView)
//        }
//        view.endEditing(true)
//    }
//    
    /* Callback for when submit button is pressed */
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
//        
//        //TO DO - FIGURE OUT WHICH EVENT IS PICKED
//        let params = ["direction": rideDirection, "seats": Int(numSeatsAvailChoice.text!)!, "driverNumber": Int(driverPhoneNumber.text!)!, "event": "563b11135e926d03001ac15c", "driverName": driverFullName.text!, "gcm_id" : 1234567]
//
//        do {
//            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
//            dbClient.addData("ride", body : body)
//        } catch {
//            print("Error sending data to database")
//        }
//        
//        /* Show a visual alert displaying successful signup */
//        let successAlert = UIAlertController(title: "Success!", message:
//            "Thank you/Users/tammy/OneDrive/Cal Poly/Senior/iCrew/CruApp/EventDetailsViewController.swift for signing up as a driver!", preferredStyle: UIAlertControllerStyle.Alert)
//        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
//            {
//                (action: UIAlertAction!) -> Void in
//                self.performSegueWithIdentifier("finishQuestionaire", sender: self)
//            }))
//    
//        self.presentViewController(successAlert, animated: true, completion: nil)
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
//            for (var i = 0; i < cells.count; i++) {
//                if (i != indexPath.row && cells[i].expanded == true) {
//                    cells[i].selectedInTableView(tableView)
//                }
//            }
        }
        else if (cell.isKindOfClass(ScrollPickerCell)) {
            let pickerTableViewCell = cell as! ScrollPickerCell
            pickerTableViewCell.selectedInTableView(tableView)
            self.infoTable.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Collapses all other cells
//            for (var i = 0; i < cells.count; i++) {
//                if (i != indexPath.row && cells[i].expanded == true) {
//                    cells[i].selectedInTableView(tableView)
//                }
//            }
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
//        var cell = UITableViewCell()
//        
//        switch (indexPath.row) {
//        case 0:
//            cell = tableView.dequeueReusableCellWithIdentifier("nameCell", forIndexPath: indexPath) as! NameFieldCell
//            break
//        case 1:
//            cell = tableView.dequeueReusableCellWithIdentifier("phoneNumCell", forIndexPath: indexPath) as! PhoneNumCell
//            break
//        case 2:
//            cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! ScrollPickerCell
//            break
//        case 3:
//            cell = tableView.dequeueReusableCellWithIdentifier("availSeatCell", forIndexPath: indexPath) 
//            break
//        case 4:
//            cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as! DatePickerCell
//            break
//        default:
//            break
//        }
//        
//        return cell
        return cells[indexPath.row] as! UITableViewCell
    }


}

extension DriverQuestionnaireVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithPlace place: GMSPlace!) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.locationLabel.text = place.formattedAddress!
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didFailAutocompleteWithError error: NSError!) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}