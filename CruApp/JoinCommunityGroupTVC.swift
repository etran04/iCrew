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
    
    var selectedMinistry : MinistryData!
    var cgCollection = [CommunityGroupData]()
    var days: [Int] = []
    var selectedIndices : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        
        //setup database
        DBClient.getData("communitygroups", dict: setCommunityGroups)
        
    }
    
    
    //obtain information from the database to an Object
    func setCommunityGroups(communityGroups: NSArray) {

        for communityGroup in communityGroups {
            let ministryId = communityGroup["ministry"] as! String
            
              //go through the community groups,
            //if the community group is in the selected ministry,
            //add it to the cgCollection
            if ministryId == selectedMinistry.id
                && days.contains(getDayOfWeek(communityGroup["meetingTime"] as! String)!){
                
                let cgObj = CommunityGroupData(id: communityGroup["_id"] as! String, name: communityGroup["name"] as! String , ministryId: communityGroup["ministry"] as! String, time: communityGroup["meetingTime"] as! String, leaders: communityGroup["leaders"] as! [String])
                cgCollection.append(cgObj)
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cgCollection.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("communityGroupCell", forIndexPath: indexPath) as! CommunityGroupCell
        
        let communityGroup = cgCollection[indexPath.row]
        
        cell.nameLabel!.text = communityGroup.name
        
        return cell
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedMinistry.name
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cgSuccess = segue.destinationViewController as!  CGSuccessVC
        
//        //sending in selected community groups
//        for index in selectedIndices {
//            cgSuccess.selectedCG = (cgCollection[index.section][index.row])
//        }
        
        
    }
    
    
    //should take in a date in the format of 2016-04-26T18:06:19.000Z
    func getDayOfWeek(today:String)->Int? {
        //make today into the correct format of yyyy-MM-dd
        var tokens = today.componentsSeparatedByString("T")
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(tokens[0]) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
    }
}
