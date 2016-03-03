//
//  JoinMinistryTeamTVC.swift
//  CruApp
//
//  Created by Mariel Sanchez on 3/2/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class JoinMinistryTeamTVC: UITableViewController {
    
    var popViewController : PopUpViewControllerSwift!
    
    var ministryCollection: [MinistryData] = []
    var teamCollection = [[MinistryTeamData]]()
    var ministryTeamCollection = [MinistryTeamData]()
    
    var selectedMinistryTeam : MinistryTeamData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        //set users ministry collection and the teamMinistry collection array
        ministryCollection = UserProfile.getMinistries()
        ministryTeamCollection = UserProfile.getMinistryTeams()
        teamCollection = Array(count: ministryCollection.count, repeatedValue: [MinistryTeamData]())
    
        //setup database
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("ministryteam", dict: setTeams)
        
    }

    //obtain information from the database to an Object
    func setTeams(ministryTeams: NSArray) {
        //self.tableView.beginUpdates()
        for ministryTeam in ministryTeams {
            let ministryId = ministryTeam["parentMinistry"] as! String
        
            //go through user's ministries and if a ministry team's parentMinistry matches
            //one of the user's ministries, add to index of teamCollection that
            //corresponds to the parentMinistry
            for (index, _) in ministryCollection.enumerate() {
                if (ministryCollection[index].id == ministryId) {
                    if(ministryTeam["description"] == nil) {
                        continue
                    }
                    
                    let teamObj = MinistryTeamData(
                        name: ministryTeam["name"] as! String,
                        description: ministryTeam["description"] as! String,
                        parentMinistry: ministryTeam["parentMinistry"] as! String,
                        id: ministryTeam["_id"] as! String)
                    
                    teamCollection[index].append(teamObj)
                }
            }
        }

        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ministryCollection.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teamCollection[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MinistryTeam", forIndexPath: indexPath) as! MinistryTeamTableViewCell

        let team = teamCollection[indexPath.section][indexPath.row]
        
        cell.teamName.text = team.name
        cell.section = indexPath.section
        cell.row = indexPath.row

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ministryCollection[section].name
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        viewInfo(cell)
    }
    
    func viewInfo(sender: AnyObject) {
        let team = teamCollection[sender.section][sender.row]
        
        let loginController = UIAlertController(title: team.name, message: team.description, preferredStyle: UIAlertControllerStyle.Alert)
        
        let signupAction = UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
            UserProfile.addMinistryTeam(team)
            self.performSegueWithIdentifier("MinistryTeamSuccessSeg", sender: self)
        }


        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        loginController.addAction(signupAction)
        loginController.addAction(cancelAction)
        
        self.presentViewController(loginController, animated: true, completion: nil)
    }
}
