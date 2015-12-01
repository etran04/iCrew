//
//  CreateEventViewController.swift
//  CruApp
//
//  Created by Jordan Tang on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import EventKit

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var eventNameField: UITextField!
    
    @IBOutlet weak var eventStartField: UITextField!
    
    @IBOutlet weak var eventEndField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEvent(sender: UIButton) {
        
        let eventName = self.eventNameField.text
        let eventStart = self.eventStartField.text
        let eventEnd = self.eventEndField.text
        
        var eventService:EventService!
        eventService = EventService()
        eventService.postEvent(eventName!)
        
        // 1
        let eventStore = EKEventStore()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:ss"
        
        let startDate = dateFormatter.dateFromString(eventStart!)
        
        let endDate = dateFormatter.dateFromString(eventEnd!)
        
        //let startDate = NSDate()
        //let endDate = startDate.dateByAddingTimeInterval(60 * 60)
        
        if(EKEventStore.authorizationStatusForEntityType(.Event) !=
            EKAuthorizationStatus.Authorized) {
                eventStore.requestAccessToEntityType(.Event, completion: {
                    granted, error in
                    self.createEvent(eventStore, title: eventName!, startDate: startDate!, endDate: endDate!)
                })
                
                
        }
        else {
            createEvent(eventStore, title: eventName!, startDate: startDate!, endDate: endDate!)
        }
    }
    @IBOutlet weak var addEvent: UIButton!
    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
