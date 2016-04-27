//
//  MinistryTeamSuccessVC.swift
//  CruApp
//
//  Created by Daniel Lee on 2/29/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class MinistryTeamSuccessVC: UIViewController {

    var ministryTeam: MinistryTeamData?
    var leaderCollection = [UserData]()
    
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var leaderName: UILabel!
    @IBOutlet weak var leaderEmail: UILabel!
    @IBOutlet weak var leaderPhone: UILabel!
    
    @IBAction func finishPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setup database
        DBClient.getData("users", dict: setLeaders)
        

    }
    
    
    //obtain information from the database to an Object
    func setLeaders(users: NSArray) {
        for user in users {
            let userId = user["_id"] as! String
            
            
            
            for leader in ministryTeam!.leaders {
                if (leader == userId) {
                    
                    let userObj = UserData(user: user)
                    
                    leaderCollection.append(userObj)
                    print(leaderCollection.count)
                }
            }
        }
        
        if let team = ministryTeam {
            confirmationLabel.text = "You have signed up to join the " + team.name
            
            if (leaderCollection.count == 0) {
                leaderName.text = "No leader information found"
                leaderEmail.text = ""
                leaderPhone.text = ""
            }
            else {
                
                //TO DO: loop throuh for multiple leaders
                leaderName.text = leaderCollection[0].firstName + " " + leaderCollection[0].lastName
                leaderEmail.text = leaderCollection[0].email
                leaderPhone.text = String(leaderCollection[0].phone)
            }
            
            
            
            
        }
        else {
            confirmationLabel.text = "You have signed up to join a Ministry Team"
        }
        
    }
    

}
