//
//  ToolTableViewCell.swift
//  CruApp
//
//  Created by Eric Tran on 2/17/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

/* ArticleTableViewCell is a representation of a single cell in our table view controller.
* It contains video information that will populate and display an article in the cell */
class ToolTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toolNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setName(name: String) {
        toolNameLabel.text = name
    }
    
}
