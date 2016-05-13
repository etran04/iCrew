//
//  InternetHelper.swift
//  CruApp
//
//  Created by Daniel Lee on 5/12/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift
import SwiftLoader

class InternetHelper : UIViewController {
    func checkInternet(controller: UIViewController) -> Bool {
        
        // Checks for internet connectivity (Wifi/4G)
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return false
        }
        
        SwiftLoader.show(title: "Loading...", animated: true)
        
        if (reachability.isReachable()) {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            SwiftLoader.hide()
            
            return true
        }
        else {
            // If unreachable, hide the loading indicator anyways
            SwiftLoader.hide()
            
            // If no internet, display an alert notifying user they have no internet connectivity
            let g_alert = UIAlertController(title: "Checking for Internet...", message: "If this dialog appears, please check to make sure you have internet connectivity. ", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // Dismiss alert dialog
                print("Dismissed No Internet Dialog")
            }
            g_alert.addAction(OKAction)
            
            controller.presentViewController(g_alert, animated: true, completion: nil)
            
            return false
        }
//
//        // If device does have internet
//        reachability.whenReachable = { reachability in
//            dispatch_async(dispatch_get_main_queue()) {
//                if reachability.isReachableViaWiFi() {
//                    print("Reachable via WiFi")
//                } else {
//                    print("Reachable via Cellular")
//                }
//                e
//                // Get the user's ministries, and load the events
//                self.ministryCollection = UserProfile.getMinistries()
//                DBClient.getData("events", dict: self.setEvents)
//            }
//        }
//
//        reachability.whenUnreachable = { reachability in
//            dispatch_async(dispatch_get_main_queue()) {
//                
//                // If unreachable, hide the loading indicator anyways
//                SwiftLoader.hide()
//                
//                // If no internet, display an alert notifying user they have no internet connectivity
//                let g_alert = UIAlertController(title: "Checking for Internet...", message: "If this dialog appears, please check to make sure you have internet connectivity. ", preferredStyle: .Alert)
//                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                    // Dismiss alert dialog
//                    print("Dismissed No Internet Dialog")
//                }
//                g_alert.addAction(OKAction)
//                
//                // Sets up the controller to display notification screen if no events populate
//                self.tableView.emptyDataSetSource = self;
//                self.tableView.emptyDataSetDelegate = self;
//                self.tableView.reloadEmptyDataSet()
//                
//                self.presentViewController(g_alert, animated: true, completion: nil)
//            }
//        }
        
       

    }
}