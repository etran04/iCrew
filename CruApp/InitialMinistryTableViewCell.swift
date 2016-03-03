//
//  InitialMinistryTableViewCell.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class InitialMinistryTableViewCell: UITableViewCell {

    @IBOutlet var ministry: UILabel!
    @IBOutlet var infoButton: MyButton!
    
    
    override func awakeFromNib() {
        
        let infoImage = UIImage(named: "info.png")
        infoButton.setImage(infoImage, forState: .Normal)
        
    }
}
