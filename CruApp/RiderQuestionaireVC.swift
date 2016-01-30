//
//  RiderQuestionaireVC.swift
//  CruApp
//
//  Created by Eric Tran on 1/28/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import DownPicker
import CheckmarkSegmentedControl

/* This class is used to gather information from a potential rider of the RideShare feature */
class RiderQuestionaireVC: UIViewController {

    @IBOutlet weak var driveTypes: CheckmarkSegmentedControl!
    @IBOutlet weak var eventsChoice: UITextField!
    
    var eventDownPicker: DownPicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* prepares fields to be filled for questionaire */
        initializeChoices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Helper method to populate choices for # of seats available */
    func initializeChoices() {
        
        /* set up radio buttons */
        driveTypes.options = [
            CheckmarkOption(title:"To & From Event \n(Round Trip)"),
            CheckmarkOption(title: "To Event \n(One-way)"),
            CheckmarkOption(title: "From Event \n(One-way)")]
        driveTypes.addTarget(self, action: "optionSelected:", forControlEvents: UIControlEvents.ValueChanged)
        
        /* TO DO: populate event choices */
        let eventChoices = ["event1", "event2", "event3"]
        self.eventDownPicker = DownPicker(textField: self.eventsChoice, withData: eventChoices)
    }

    /* Callback for when a new radio button is clicked */
    func optionSelected(sender: AnyObject) {
        print("RiderQ - Selected option: \(driveTypes.options[driveTypes.selectedIndex])")
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
