//
//  JoinCommunityGroupTVC.swift
//  CruApp
//
//  Created by Daniel Lee on 3/3/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class JoinCommunityGroupTVC: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var popViewController : PopUpViewControllerSwift!
    
    var ministryCollection: [MinistryData] = []
    var cgCollection = [[CommunityGroupData]]()
//    var ministryTeamCollection = [CommunityGroupData]()
    
    var selectedIndices : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        //set users ministry collection and the teamMinistry collection array
        ministryCollection = UserProfile.getMinistries()
//        ministryTeamCollection = UserProfile.getMinistryTeams()
        cgCollection = Array(count: ministryCollection.count, repeatedValue: [CommunityGroupData]())
        
        //setup database
        var dbClient: DBClient!
        dbClient = DBClient()
//        dbClient.getData("communitygroup", dict: setCommunityGroups)
        
        setMockData()
    }
    
    func setMockData() {
        
        for (var count = 0; count < 5; count++) {
            for (var i = 0; i < ministryCollection.count; i++) {
                cgCollection[i].append(CommunityGroupData(id: "Community Group \(count)\(i)", ministryId: "123", time: NSDate(), leaders: "Lalala"))
            }
        }
    }
    
    //obtain information from the database to an Object
    func setCommunityGroups(communityGroups: NSArray) {
        for communityGroup in communityGroups {
            let ministryId = communityGroup["parentMinistry"] as! String
            
            //go through user's ministries and if a ministry team's parentMinistry matches
            //one of the user's ministries, add to index of teamCollection that
            //corresponds to the parentMinistry
            for (index, _) in ministryCollection.enumerate() {
                if (ministryCollection[index].id == ministryId) {
                    let cgObj = CommunityGroupData(
                        id: communityGroup["name"] as! String,
                        ministryId: ministryId,
                        time: communityGroup["meetingTime"] as! NSDate,
                        leaders: communityGroup["leaders"] as! String)
                    
                    cgCollection[index].append(cgObj)
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
        
        return cgCollection[section].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("communityGroupCell", forIndexPath: indexPath) as! CommunityGroupCell
        
        let communityGroup = cgCollection[indexPath.section][indexPath.row]
        
        cell.nameLabel!.text = communityGroup.id
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ministryCollection[section].name
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if (!selectedIndices.contains(indexPath.row)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedIndices.append(indexPath.row)
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedIndices.removeAtIndex(selectedIndices.indexOf(indexPath.row)!)
        }
        
        doneButton.enabled = selectedIndices.count > 0
    }
}
