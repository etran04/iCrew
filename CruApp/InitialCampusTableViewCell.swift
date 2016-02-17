//
//  InitialCampusTableViewCell.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class InitialCampusTableViewCell: UITableViewCell {

    @IBOutlet var campus: UILabel!

    @IBOutlet var infoButton: UIButton!
    
    override func awakeFromNib() {
        
        let infoImage = UIImage(named: "info.png")
        infoButton.setImage(infoImage, forState: .Normal)

    }

}
