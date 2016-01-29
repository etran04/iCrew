//
//  ResourcesViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController {
    
    @IBOutlet weak var textButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func text(sender: UIButton) {
        // print("texting...")
        //        let twilioUsername = "ACc18e4b9385be579bdb48ca5526414403"
        //        let twilioPassword = "c5e0f0de4c90c803595851a7554c9a98"
        //
        //        let data = [
        //            "To" : "+17078038796",
        //            "From" : "+17074193527",
        //            "Body" : "It works!"
        //        ]
        //
        //        Alamofire.request(.POST, "https://\(twilioUsername):\(twilioPassword)@api.twilio.com/2010-04-01/Accounts/\(twilioUsername)/Messages", parameters: data)
        //            .responseData { response in
        //                print(response.request)
        //                print(response.response)
        //                print(response.result)
        //        }
        let localNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS 8"
        localNotification.alertBody = "Eric is a poop in butt"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "invite"
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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
