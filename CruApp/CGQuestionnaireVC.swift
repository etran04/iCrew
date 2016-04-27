//
//  CGQuestionnaireVC.swift
//  CruApp
//
//  Created by Daniel Lee on 2/29/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit


class CGQuestionnaireVC: UIViewController {

    @IBOutlet weak var dayPicker: MWSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        for num in dayPicker.getSelected() {
            print(num)
        }
        
        let joinCG = segue.destinationViewController as!  JoinCommunityGroupTVC
        joinCG.days = dayPicker.getSelected()
        
    }

}
