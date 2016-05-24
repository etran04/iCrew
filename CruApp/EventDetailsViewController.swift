//
//  EventDetailsViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 1/15/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import EventKit
import SafariServices

class EventDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    //Event detail labels
    @IBOutlet weak var eventImage: UIImageView!     //image banner for the event
    @IBOutlet weak var eventTitle: UILabel!         //title of the event
    @IBOutlet weak var eventLocation: UILabel!      //location of the event
    @IBOutlet weak var eventDate: UILabel!          //date and time of the event
    @IBOutlet weak var eventDescr: UILabel!         //description of the event
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //buttons linked to the event
    @IBOutlet weak var facebookButton: UIButton!    //Facebook button to the event page
    @IBOutlet weak var googleButton: UIButton!      //Google button to save event to Google calendar
    @IBOutlet weak var calendarButton: UIButton!    //calendar button to save event to native calendar
    
    @IBOutlet weak var rideSharebutton: UIBarButtonItem!
    
    //Keys for accessing Google API
    //These will need to be changed upon release
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "466090597779-cqphfvmo2focdg82kpm2rh5qg4u0vgkd.apps.googleusercontent.com"
    private let kSecret = "fyM1MvYHSkXPl9plSlkYgYcw"
    private let scopes = [kGTLAuthScopeCalendar, "https://www.googleapis.com/auth/calendar"]
    private let service = GTLServiceCalendar()
    
    //@IBOutlet var heightScrollConstraint: NSLayoutConstraint!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checks if user's google account is already identified
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: kSecret) {
                service.authorizer = auth
        }
        
        //load details
        loadEventDetails()
        loadButtons()
        
        //for scrolling
        let screenWidth = UIScreen.mainScreen().bounds.width
        let scrollHeight = eventDescr.frame.origin.y + eventDescr.frame.height
        self.scrollView.contentSize = CGSizeMake(screenWidth, scrollHeight)
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load event data to display on screen
    func loadEventDetails() {
        if let event = event {
            eventTitle.text = event.name
            eventTitle.font = UIFont(name: "FreightSansProSemiBold-Regular", size: 22)
            eventDescr.text = event.description
            eventDescr.sizeToFit()
            eventLocation.text = (event.location?.getLocation())!
            eventLocation.sizeToFit()
            
            //date formatting
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let startDate = dateFormatter.dateFromString(event.startDate!)
            let endDate = dateFormatter.dateFromString(event.endDate!)
            dateFormatter.dateFormat = "MM/dd/YY"
            
            //checks if start and end date are the same
            if(dateFormatter.stringFromDate(startDate!) == dateFormatter.stringFromDate(endDate!)) {
                eventDate.text = dateFormatter.stringFromDate(startDate!)
                dateFormatter.timeStyle = .ShortStyle
                eventDate.text! += ", " + dateFormatter.stringFromDate(startDate!) + " – " + dateFormatter.stringFromDate(endDate!)
                
            } else {
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .ShortStyle
                eventDate.text = dateFormatter.stringFromDate(startDate!) + " – " + dateFormatter.stringFromDate(endDate!)
            }
            
            //image formatting
            let oldWidth = eventImage.frame.size.width
            let oldHeight = eventImage.frame.size.height
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            let newHeight = screenWidth * oldHeight / oldWidth
            var image = UIImage(named: "CruIcon")
            
            
            //Load event image if available
    
            if (event.image != nil) {
                let url = NSURL(string: event.image!)
                if let data = NSData(contentsOfURL: url!) {
                    image = UIImage(data: data)
                }
            }
            
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            eventImage.frame = eventImage.bounds
            
            // 10 added to width to fill in buffered white space 
            imageView.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: newHeight)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            eventImage.addSubview(imageView)
        }
    }
    
    //set actions to the buttons
    func loadButtons() {
        if let event = event {
            // Calendar button
            calendarButton.setTitle("", forState: UIControlState.Normal)
            calendarButton.addTarget(self, action: #selector(EventDetailsViewController.syncCalendar(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            // Facebook button
            if (event.url != "") {
                facebookButton.setTitle("", forState: UIControlState.Normal)
                facebookButton.addTarget(self, action: #selector(EventDetailsViewController.openFacebook(_:)), forControlEvents: .TouchUpInside)
            } else {
                facebookButton.enabled = false
            }
            
            //Google calendar button
            googleButton.setTitle("", forState: UIControlState.Normal)
            googleButton.addTarget(self, action: #selector(EventDetailsViewController.googleCalendarSync(_:)),
                forControlEvents: UIControlEvents.TouchUpInside)
            
            // check if ridesharing for event is enabled
            if (event.rideShareFlag == false) {
                self.rideSharebutton.enabled = false
            }
        }
    }
    
    //opens up Facebook when Facebook button is selected
    func openFacebook(sender:UIButton!) {
        if let url = NSURL(string: (event?.url)!) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    //Triggered when calendar button is pressed, gets information to make event
    func syncCalendar(sender: UIButton!) {
        //let event = eventsCollection[Int(sender.titleLabel!.text!)!]
        if let event = event {
            let name = event.name
        
            let eventStore = EKEventStore()
            let dateFormatter = NSDateFormatter()
            //2015-11-19T22:00:00.000Z
            //dateFormatter.dateFormat = "MMM dd, yyyy, HH:ss"
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
            let startDate = dateFormatter.dateFromString(event.startDate!)
            let endDate = dateFormatter.dateFromString(event.endDate!)
        
            //checks for authorization to access calendar
            if(EKEventStore.authorizationStatusForEntityType(.Event) !=
                EKAuthorizationStatus.Authorized) {
                    eventStore.requestAccessToEntityType(.Event, completion: {
                        granted, error in self.createEvent(eventStore, title: name, startDate: startDate!, endDate: endDate!)
                    })
            } else {
                createEvent(eventStore, title: name, startDate: startDate!, endDate: endDate!)
            }
            //Alert if calendar sync was succesful
            let alertController = UIAlertController(title: name, message:
                "Event synced to calendar", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //Creates event and inserts event into local calendar
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch {
            print("Event was unable to be saved.")
        }
    }
    
    //Sync event to Google Calendar, check for authorization
    func googleCalendarSync(sender: UIButton!) {
        if let event = event{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let startDate = dateFormatter.dateFromString(event.startDate!)
            let endDate = dateFormatter.dateFromString(event.endDate!)
            
            //If needed, get user credentials to access Google account
            if let authorizer = service.authorizer,
                canAuth = authorizer.canAuthorize where canAuth {
                    insertGoogleEvent(event.name, startDate: startDate!, endDate: endDate!, desc: event.description)
            } else {
                presentViewController(
                    createAuthController(),
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    //Insert a new event to Google Calendar
    func insertGoogleEvent(title: String, startDate: NSDate, endDate: NSDate, desc: String) {
        let event = GTLCalendarEvent()
        
        let eventStart = GTLDateTime(date: startDate, timeZone: NSTimeZone.localTimeZone())
        let eventEnd = GTLDateTime(date: endDate, timeZone: NSTimeZone.localTimeZone())
        
        event.summary = title
        event.start = GTLCalendarEventDateTime()
        event.end = GTLCalendarEventDateTime()
        
        event.start.dateTime = eventStart
        event.end.dateTime = eventEnd
        event.descriptionProperty = desc
        
        let calendarID = "primary"
        let query = GTLQueryCalendar.queryForEventsInsertWithObject(event, calendarId: calendarID)
        
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: "finishInsert:finishedWithObject:error:"
        )
    }
    
    //Error if couldn't sync to calendar
    func finishInsert(
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
            
            if let error = error {
                showAlert("Error", message: error.localizedDescription)
                return
            }
            else {
                showAlert("Synced", message: "Synced event to calendar")
            }
    }
    
    // Creates the auth controller for authorizing access to Google Calendar API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: kSecret,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    
    // Handle completion of the authorization process, and update the Google Calendar API
    // with the new credentials.
    func viewController(vc : UIViewController,
        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
            
            if let error = error {
                service.authorizer = nil
                showAlert("Authentication Error", message: error.localizedDescription)
                return
            }
            service.authorizer = authResult
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func rideSharePressed(sender: UIBarButtonItem) {
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: eventTitle.text!, message: "What would you like for the event?", preferredStyle: .ActionSheet)
        
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
        
            //Create and add first option action
            let offerRideAction: UIAlertAction = UIAlertAction(title: "Offer a ride", style: .Default)
                { action -> Void in
                    print("offer a ride selected")
                    self.performSegueWithIdentifier("goToOfferRide", sender: self)
            }
            actionSheetController.addAction(offerRideAction)
        
            //Create and add a second option action
            let requestRideAction: UIAlertAction = UIAlertAction(title: "Request a ride", style: .Default)
                { action -> Void in
                    print("request a ride selected")
                    self.performSegueWithIdentifier("goToRequestRide", sender: self)
            }
            actionSheetController.addAction(requestRideAction)
        
            //We need to provide a popover sourceView when using it on iPad
            //actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}
