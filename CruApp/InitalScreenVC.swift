//
//  InitalScreenVC.swift
//  CruApp
//
//  Created by Daniel Lee on 2/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class InitalScreenVC: UIViewController {
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if (UserProfile.getCampuses().count > 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("mainRootViewController") as! SWRevealViewController
            appDelegate.window?.rootViewController = viewController
        }
        else {
            let storyboard = UIStoryboard(name: "Initial", bundle: nil)
            let navController = storyboard.instantiateViewControllerWithIdentifier("initialNavController") as! UINavigationController
            appDelegate.window?.rootViewController = navController
        }
    }
}
