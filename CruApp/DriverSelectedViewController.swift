//
//  DriverSelectedViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class DriverSelectedViewController: UIViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverNumber: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    
    var driver : Driver!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverName.text = "Driver's Name: " + driver.name
        eventName.text = ""
        driverNumber.text = "Driver's Phone Number: " + driver.number
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        departureTime.text = "Departure Time: " + dateFormatter.stringFromDate(date!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
