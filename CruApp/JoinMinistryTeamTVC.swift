//
//  JoinMinistryTeamTVC.swift
//  CruApp
//
//  Created by Mariel Sanchez on 3/2/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class JoinMinistryTeamTVC: UITableViewController {
    
    var ministryCollection: [MinistryData] = []
    var teamCollection = [[MinistryTeam]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        //set users ministry collection and the teamMinistry collection array
        ministryCollection = UserProfile.getMinistries()
        teamCollection = Array(count: ministryCollection.count, repeatedValue: [MinistryTeam]())
    
        //setup database
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("ministryteam", dict: setTeams)
        
    }

    //obtain information from the database to an Object
    func setTeams(ministryteams:NSArray) {
        //self.tableView.beginUpdates()
        for ministryteam in ministryteams {
        
            var existsInMinistry = false
            let ministryId = ministryteam["parentMinistry"] as! String
        
            //go through user's ministries and if a ministry team's parentMinistry matches
            //one of the user's ministries, add to index of teamCollection that
            //corresponds to the parentMinistry
            for (index, _) in ministryCollection.enumerate() {
                if (ministryCollection[index].id == ministryId) {
                    let teamObj = MinistryTeam(name: ministryteam["name"] as! String, description: ministryteam["description"] as! String, parentMinistry: ministryteam["parentMinistry"] as! String)
                    teamCollection[index].append(teamObj)
                    existsInMinistry = true;
                }
            }
        
        
//        if (!existsInMinistry) {
//            return;
//        }
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

        

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ministryCollection[section].name
    }

}
