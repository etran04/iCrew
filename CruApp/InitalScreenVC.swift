//
//  InitalScreenVC.swift
//  CruApp
//
//  Created by Daniel Lee on 2/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Cocoa

class InitalScreenVC: UIViewController {
    override func viewDidLoad() {
        if (UserProfile.getCampuses().count > 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("mainRootViewController") as! SWRevealViewController
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController
        }
    }
}
