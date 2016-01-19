//
//  MissionDetailsViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 1/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import SafariServices

class MissionDetailsViewController: UIViewController {
    
    var mission: Mission?


    @IBOutlet weak var missionImage: UIImageView!
    @IBOutlet weak var missionTitle: UILabel!
    @IBOutlet weak var missionLeaders: UILabel!

    @IBOutlet weak var missionButton: UIButton!
    @IBOutlet weak var missionDescr: UITextView!
    @IBOutlet weak var missionCost: UILabel!
    @IBOutlet weak var missionLocation: UILabel!
    @IBOutlet weak var missionDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let mission = mission {
            missionTitle.text = mission.name
            missionDescr.text = mission.description
            missionLocation.text = (mission.location?.getLocation())!
            missionCost.text = "$" + String(mission.cost)
            missionLeaders.text = mission.leaders
            
            //date formatting
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let startDate = dateFormatter.dateFromString(mission.startDate!)
            let endDate = dateFormatter.dateFromString(mission.endDate!)
            dateFormatter.dateFormat = "MM/dd/YY"
            missionDate.text = dateFormatter.stringFromDate(startDate!) + " - " + dateFormatter.stringFromDate(endDate!)
            
    
            // Mission link button
            if (mission.url != "") {
                //missionButton.setTitle(, forState: UIControlState.Normal)
                missionButton.addTarget(self, action: "openLink:", forControlEvents: .TouchUpInside)
            } else {
                missionButton.enabled = false
            }
            
            //Load event image is available
            if (mission.image != nil && mission.image != "") {
                let url = NSURL(string: mission.image!)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                let imageView = UIImageView(image: image)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.clipsToBounds = true
                missionImage.bounds.size.height = 112
                missionImage.bounds.size.width = 329
                imageView.frame = missionImage.bounds
                missionImage.contentMode = UIViewContentMode.ScaleAspectFit
                missionImage.addSubview(imageView)
            } else {
                let imageName = "Cru-Logo.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.clipsToBounds = true
                missionImage.bounds.size.height = 112
                missionImage.bounds.size.width = 329
                imageView.frame = missionImage.bounds
                missionImage.contentMode = UIViewContentMode.ScaleAspectFit
                missionImage.addSubview(imageView)
            }
        }
    }
    
    func openLink(sender:UIButton!) {
        //let event = eventsCollection[Int(sender.titleLabel!.text!)!]
        
        if let url = NSURL(string: (mission?.url)!) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: false, completion: nil)
        }
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
