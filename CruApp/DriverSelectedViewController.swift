//
//  DriverSelectedViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class DriverSelectedViewController: UIViewController {

    @IBOutlet weak var driverContactInfoLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverNumber: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    
    var driver : Driver!
    var dbClient: DBClient!

    var eventNames = [String]()
    var eventIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dbClient = DBClient()
        dbClient.getData("event", dict: setEvents)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Obtain event information from the database to an Object
    func setEvents(events: NSArray) {
        for event in events {
            let name = event["name"] as! String
            let id = event["_id"] as! String
            self.eventNames.append(name)
            self.eventIds.append(id)
        }
        
        for index in 0...(eventIds.count - 1) {
            if(eventIds[index] == driver.eventId) {
                eventName.text = eventNames[index]
                break
            }
        }
        
        driverName.text = "Driver's Name: " + driver.name
        driverNumber.text = "Driver's Phone Number: " + driver.number
        successLabel.font = UIFont.boldSystemFontOfSize(24)
        successLabel.font = successLabel.font.fontWithSize(20)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        departureTime.text = "Departure Time: " + dateFormatter.stringFromDate(date!)
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
