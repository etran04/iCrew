//
//  SelectDriverTableViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import AddressBookUI

class SelectDriverTableViewController: UITableViewController {
    var passenger : Passenger!
    var driverCollection = [Driver]()
    /*maps variables*/
    var selectView: UIView?
    var latitude: Double?
    var longitude: Double?
    var cityZip: String = "93405"
    
    /*api keys*/
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyCLsWMvLiBIEh76VETPgd6fQkeLo0LIJ7g"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("ride", dict: setDrivers)
        selectView = self.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDrivers(drivers:NSArray) {
        
        for driver in drivers {
            
        
            let eventId = driver["event"] as! String
            let availableSeats = (driver["seats"] as! Int) - (driver["passengers"]!!.count) as Int
            let time = driver["time"] as! String
            var direction = ""
        
            if(driver["direction"]! != nil) {
                direction = driver["direction"] as! String
            }
            
            let zipcode = driver["location"]?!.objectForKey("postcode") as! String
            let state = driver["location"]?!.objectForKey("state") as! String
            var city = ""
            
            if(driver["location"]?!.objectForKey("suburb") != nil) {
                city = driver["location"]?!.objectForKey("suburb") as! String
            }
            let street = driver["location"]?!.objectForKey("street1") as! String
            let country = driver["location"]?!.objectForKey("country") as! String
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let driverTime = dateFormatter.dateFromString(time)
        
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z'"
            let passengerTime = dateFormatter.dateFromString(passenger.time)

            
            if (passenger.eventId == eventId
                && availableSeats != 0
                && driverTime!.compare(passengerTime!) == NSComparisonResult.OrderedAscending
                && direction == passenger.direction) {
                    let id = driver["_id"] as! String
                    let name = driver["driverName"] as! String
                    let driverNumber = driver["driverNumber"] as! String
            
                    let driverObj = Driver(id: id, name: name, number : driverNumber, eventId: eventId, departureTime: time, state: state, street: street, country: country, zipcode: zipcode, city: city)
            
                    driverCollection.append(driverObj)
            }
        }
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return driverCollection.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SelectRideCell", forIndexPath: indexPath) as! SelectDriverTableViewCell
        cell.tableController = self
        let driver = driverCollection[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(date!)
        
        cell.driverName.text = "Name: " + driver.name
        cell.driverNumber.text = "Phone Number: " + driver.number
        cell.depatureTime.text = "Departure Time: " + dateString
        cell.location.text = "Location: " + driver.street + ", " + driver.city + ", " + driver.state + ", " + driver.country + " " + driver.zipcode

        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let selectedDriverViewController = segue.destinationViewController as! DriverSelectedViewController
        if let selectedDriverCell = sender as? SelectDriverTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedDriverCell)!
            let selectedDriver = driverCollection[indexPath.row]
            
            let params =
            [
                "name": passenger.name,
                "direction": passenger.direction,
                "phone": passenger.phoneNumber,
                "gcm_id" : 1234567
            ]
            
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                var dbClient: DBClient!
                dbClient = DBClient()
                dbClient.addPassenger(selectedDriver.id, action: "passenger", body : body)
            } catch {
                print("Error sending data to database")
            }
            
            
            selectedDriverViewController.driver = selectedDriver
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    
    func showMap(row: Int) {
        let currentRide = driverCollection[row]
        let location = currentRide.street

        getLatLngForZip(cityZip)
        let camera = GMSCameraPosition.cameraWithLatitude(latitude!, longitude: longitude!, zoom: 15)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(50, 50, 50, 25)
        button.frame.origin = CGPoint(x: 40, y: 100)
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("Back", forState: UIControlState.Normal)
        button.addTarget(self, action: "goBack:", forControlEvents: UIControlEvents.TouchUpInside)

        forwardGeocoding(location)
        let  position = CLLocationCoordinate2DMake(latitude!, longitude!)
        let marker = GMSMarker(position: position)
        marker.title = "Test Marker"
        marker.map = mapView
        
        mapView.addSubview(button)
        self.view = mapView

    }
    
    func goBack(sender:UIButton!)
    {
        print("Button tapped")
        self.view = selectView;
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
                if placemark?.areasOfInterest?.count > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    func getLatLngForZip(zipCode: String) {
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    latitude = location["lat"] as! Double
                    longitude = location["lng"] as! Double
                    print("\n\(latitude), \(longitude)")
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
