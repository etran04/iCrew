//
//  ActivityViewController.swift
//  CruApp
//
//  Created by Daniel Lee on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewController {
    @IBOutlet weak var textButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textButton.target = self
        self.textButton.action = "text:"
    }
    
    override func viewDidAppear(animated: Bool) {
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func text(sender: UIBarButtonItem) {
        print("texting...")
        let twilioUsername = "ACc18e4b9385be579bdb48ca5526414403"
        let twilioPassword = "c5e0f0de4c90c803595851a7554c9a98"
        
        let data = [
            "To" : "+17078038796",
            "From" : "+17074193527",
            "Body" : "It works!"
        ]
        
        Alamofire.request(.POST, "https://\(twilioUsername):\(twilioPassword)@api.twilio.com/2010-04-01/Accounts/\(twilioUsername)/Messages", parameters: data)
            .responseData { response in
                print(response.request)
                print(response.response)
                print(response.result)
        }
    }
}