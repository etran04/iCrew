//
//  NameFieldCell.swift
//  CruApp
//
//  Created by Eric Tran on 3/1/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class NameFieldCell: UITableViewCell {

    @IBOutlet weak var driverFullName: UITextField!
    
    @IBOutlet weak var riderFullName: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
