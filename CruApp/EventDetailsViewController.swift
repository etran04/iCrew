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

class EventDetailsViewController: UIViewController {
    @IBOutlet weak var eventImage: UIImageView!     //image banner for the event
    @IBOutlet weak var eventTitle: UILabel!         //title of the event
    @IBOutlet weak var eventLocation: UILabel!      //location of the event
    @IBOutlet weak var eventDate: UILabel!          //date and time of the event
    @IBOutlet weak var eventDescr: UILabel!         //description of the event
    
    @IBOutlet weak var facebookButton: UIButton!    //Facebook button to the event page
    @IBOutlet weak var googleButton: UIButton!      //Google button to save event to Google calendar
    @IBOutlet weak var calendarButton: UIButton!    //calendar button to save event to native calendar
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = event {
            
            //load events
            eventTitle.text = event.name
            eventDescr.text = event.description
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
                
                dateFormatter.dateFormat = "H:mm"  //wuttt is thisssss?!
                dateFormatter.timeStyle = .ShortStyle
                dateFormatter.stringFromDate(startDate!)
                
                eventDate.text! += ", " + dateFormatter.stringFromDate(startDate!) + " - " + dateFormatter.stringFromDate(endDate!)
            } else {
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .ShortStyle
            
                eventDate.text = dateFormatter.stringFromDate(startDate!) + " - " + dateFormatter.stringFromDate(endDate!)
            }
            
            //load buttons
            // Calendar button
            calendarButton.setTitle(event.name, forState: UIControlState.Normal)
            calendarButton.addTarget(self, action: "syncCalendar:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
            // Facebook button
            if (event.url != "") {
                facebookButton.setTitle(event.name, forState: UIControlState.Normal)
                facebookButton.addTarget(self, action: "openFacebook:", forControlEvents: .TouchUpInside)
            } else {
                facebookButton.enabled = false
            }
        
            
            //Load event image if available
            if (event.image != nil) {
                let url = NSURL(string: event.image!)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                let imageView = UIImageView(image: image)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.clipsToBounds = true
                eventImage.bounds.size.height = 128
                eventImage.bounds.size.width = 329
                imageView.frame = eventImage.bounds
                eventImage.contentMode = UIViewContentMode.ScaleAspectFit
                eventImage.addSubview(imageView)
            } else {
                let imageName = "Cru-Logo.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.clipsToBounds = true
                eventImage.bounds.size.height = 128
                eventImage.bounds.size.width = 329
                imageView.frame = eventImage.bounds
                eventImage.contentMode = UIViewContentMode.ScaleAspectFit
                eventImage.addSubview(imageView)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openFacebook(sender:UIButton!) {
        //let event = eventsCollection[Int(sender.titleLabel!.text!)!]
        
        if let url = NSURL(string: (event?.url)!) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    func syncCalendar(sender: UIButton!) {
        //let event = eventsCollection[Int(sender.titleLabel!.text!)!]
        if let event = event {
            let name = event.name
            let start = event.startDate
            let end = event.endDate
        
            let eventStore = EKEventStore()
            let dateFormatter = NSDateFormatter()
            //2015-11-19T22:00:00.000Z
            //dateFormatter.dateFormat = "MMM dd, yyyy, HH:ss"
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
            let startDate = dateFormatter.dateFromString(start!)
        
            let endDate = dateFormatter.dateFromString(end!)
        
            if(EKEventStore.authorizationStatusForEntityType(.Event) !=
                EKAuthorizationStatus.Authorized) {
                    eventStore.requestAccessToEntityType(.Event, completion: {
                        granted, error in self.createEvent(eventStore, title: name, startDate: startDate!, endDate: endDate!)
                    })
                
                
            } else {
                createEvent(eventStore, title: name, startDate: startDate!, endDate: endDate!)
            }
            let alertController = UIAlertController(title: name, message:
                "Event synced to calendar", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch {
            print("Bad")
        }
    }

    
    // MARK: - Navigation

    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
