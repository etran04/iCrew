//
//  MainRideShareVC.swift
//  CruApp
//
//  Created by Daniel Lee on 3/10/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class MainRideShareVC: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidAppear(animated: Bool) {
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
